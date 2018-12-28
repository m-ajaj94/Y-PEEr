//
//  CreateStoryViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class CreateStoryViewController: ParentViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var issueTextField: UITextField!{
        didSet{
            issueTextField.layer.borderWidth = 0.5
            issueTextField.layer.borderColor = UIColor.mainOrange.cgColor
            issueTextField.setLeftPaddingPoints(8)
            issueTextField.setRightPaddingPoints(8)
            issueTextField.placeholder = "Select related issue".localized
            issuePicker = UIPickerView()
            issueTextField.inputView = issuePicker
            issueTextField.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var storyTextView: UITextView!{
        didSet{
            storyTextView.layer.borderWidth = 0.5
            storyTextView.layer.borderColor = UIColor.mainOrange.cgColor
            storyTextView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            storyTextView.layer.cornerRadius = 10
            storyTextView.clipsToBounds = true
            storyTextView.text = placeholderText
            storyTextView.textColor = .lightGray
            storyTextView.delegate = self
        }
    }
    @IBOutlet weak var shareButton: UIButton!{
        didSet{
            shareButton.layer.cornerRadius = shareButton.frame.height / 2
        }
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
    }
    
    var placeholderText: String! = "Enter your story".localized
    var issuePicker: UIPickerView!{
        didSet{
            issuePicker.delegate = self
            issuePicker.dataSource = self
        }
    }
    var issues: [IssueModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        title = "Share Story".localized
        hidesKeyboardOnTap()
        storyTextView.textColor = .lightGray
        requestData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if self.scrollView.contentInset.bottom != 0{
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            else{
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame!.size.height, right: 0)
            }
        }
    }
    
    @objc override func didPressRetry() {
        self.removeNoConnection()
        self.requestData()
    }
    
    func requestData(){
        showLoading()
        Networking.issues.getIssues { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.issues = model!.data!
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

}

extension CreateStoryViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == placeholderText && textView.textColor == .lightGray){
            textView.text = ""
            textView.textColor = .mainOrange
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

extension CreateStoryViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        issueTextField.text = issues[row].title!
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let label = view as? UILabel{
            label.textColor = .mainOrange
            label.textAlignment = .center
            label.text = issues[row].title!
            return label
        }
        let label = UILabel()
        label.textColor = .mainOrange
        label.textAlignment = .center
        label.text = issues[row].title!
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return issues.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
