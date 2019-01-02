//
//  EventApplyFormViewController.swift
//  
//
//  Created by Majd Ajaj on 12/29/18.
//

import UIKit

class EventApplyFormViewController: ParentViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorInset = .zero
            tableView.register(UINib(nibName: String(describing: FormTextTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FormTextTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: FormRadioTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FormRadioTableViewCell.self))
        }
    }
    @IBOutlet weak var doneButton: UIBarButtonItem!{
        didSet{
            doneButton.title = "Submit".localized
        }
    }
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        if checkValid(){
            submitRequest()
        }
        else{
            showAlert("Error".localized, "Please answer all questions".localized)
        }
    }
    
    var answers: [Int:Any] = [:]
    var eventID: Int!
    var form: FormModel!{
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        hidesKeyboardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if self.tableView.contentInset.bottom != 0{
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            else{
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame!.size.height, right: 0)
            }
        }
    }
    
    override func didPressRetry() {
        removeNoConnection()
        requestData()
    }
    
    func checkValid() -> Bool{
        for question in form.questions!{
            if answers[question.id!] == nil || (question.type! == "text" && (answers[question.id!] as! String) == ""){
                return false
            }
        }
        return true
    }
    
    func requestData(){
        showLoading()
        Networking.events.getForm(["event_id":eventID]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code! == "1"{
                    self.form = model!.data
                }
                else if model!.code! == "403"{
                    let alert = UIAlertController(title: "Sorry".localized, message: "The form is not ready yet\nTry again later".localized, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok".localized, style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.view.tintColor = .mainOrange
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.showNoConnection()
                }
            }
            else{
                self.showNoConnection()
            }
        }
    }
    
    func submitRequest(){
        var dict: [String:Any] = [:]
        dict["user_id"] = UserCache.userID
        dict["form_id"] = form.id!
        var array: [[String:Any]] = []
        for question in form.questions!{
            var tempDict: [String:Any] = [:]
            tempDict["id"] = question.id!
            if question.type! == "text"{
                tempDict["answer"] = answers[question.id!] as! String
                tempDict["option_id"] = ""
            }
            else{
                tempDict["answer"] = ""
                tempDict["option_id"] = (answers[question.id!] as! FormOptionModel).id!
            }
            array.append(tempDict)
        }
        dict["questions"] = array
        showLoading()
        Networking.events.submitForm(dict) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    let alert = UIAlertController(title: "Success".localized, message: "Your request was successfully submitted".localized, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok".localized, style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.view.tintColor = .mainOrange
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Error".localized, message: model!.message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
                    alert.view.tintColor = .mainOrange
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert = UIAlertController(title: "Error".localized, message: model!.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "Retry".localized, style: .default, handler: {(action) in
                    self.submitRequest()
                })
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
                alert.view.tintColor = .mainOrange
                alert.addAction(action)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}

extension EventApplyFormViewController: UITableViewDelegate, UITableViewDataSource, FormTextCellDelegate, FormRadioTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if form == nil{
            return 0
        }
        return form.questions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = form.questions![indexPath.row]
        if question.type! == "text"{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormTextTableViewCell.self)) as! FormTextTableViewCell
            cell.delegate = self
            cell.index = indexPath
            cell.question = question
            if answers[question.id!] == nil{
                answers[question.id!] = ""
            }
            cell.answerString = (answers[question.id!] as! String)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormRadioTableViewCell.self)) as! FormRadioTableViewCell
            cell.delegate = self
            cell.question = question
            if answers[question.id!] == nil{
                answers[question.id!] = question.options![0]
            }
            cell.selectedOption = (answers[question.id!] as! FormOptionModel)
            tableView.beginUpdates()
            tableView.endUpdates()
            return cell
        }
    }
    
    func didChangeText(_ text: String, _ question: FormQuestionModel, _ index: IndexPath) {
        answers[question.id!] = text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func didSelect(_ answer: FormOptionModel, _ question: FormQuestionModel) {
        answers[question.id!] = answer
    }
    
}
