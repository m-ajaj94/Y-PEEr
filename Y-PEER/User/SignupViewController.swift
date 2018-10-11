//
//  SignupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/10/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.placeholder = "Full Name".localized
            nameTextField.setLeftPaddingPoints(16)
            nameTextField.setRightPaddingPoints(16)
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.placeholder = "E-mail".localized
            emailTextField.setLeftPaddingPoints(16)
            emailTextField.setRightPaddingPoints(16)
            emailTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var genderTextField: UITextField!{
        didSet{
            genderTextField.placeholder = "Gender".localized
            genderTextField.setLeftPaddingPoints(16)
            genderTextField.setRightPaddingPoints(16)
            genderPicker = UIPickerView()
            genderPicker.dataSource = self
            genderPicker.delegate = self
            genderTextField.inputView = genderPicker
        }
    }
    @IBOutlet weak var cityTextField: UITextField!{
        didSet{
            cityTextField.placeholder = "City".localized
            cityTextField.setLeftPaddingPoints(16)
            cityTextField.setRightPaddingPoints(16)
            cityPicker = UIPickerView()
            cityPicker.dataSource = self
            cityPicker.delegate = self
            cityTextField.inputView = cityPicker
        }
    }
    @IBOutlet weak var birthdayTextField: UITextField!{
        didSet{
            birthdayTextField.placeholder = "Birthday".localized
            birthdayTextField.setLeftPaddingPoints(16)
            birthdayTextField.setRightPaddingPoints(16)
            datePicker = UIDatePicker()
            birthdayTextField.inputView = datePicker
        }
    }
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if emailTextField.empty{
            showErrorAlert("Please enter your e-mail first!".localized)
        }
        else{
            if !emailTextField.text!.isEmail{
                showErrorAlert("Please enter a valid e-mail!".localized)
            }
            else{
                if userInfo!.gender == nil || userInfo!.gender == 0{
                    showErrorAlert("Please select your gender!".localized)
                }
                else{
                    if userInfo!.city == nil || userInfo!.city == 0{
                        showErrorAlert("Please select your city!".localized)
                    }
                    else{
                        if userInfo!.birthday == nil{
                            showErrorAlert("Please enter your birthday!".localized)
                        }
                        else{
                            signup()
                        }
                    }
                }
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    
    var genders = ["None", "Male", "Female"]
    var cities = ["None", "Damascus", "Homs", "Aleppo", "Lattakia", "Tartous", "Dar'aa", "Der el Zour", "Hamah"]
    var datePicker: UIDatePicker!{
        didSet{
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
            datePicker.datePickerMode = .date
        }
    }
    var genderPicker, cityPicker: UIPickerView!
    var isEditProfile = false
    var userInfo: (name: String?, email: String?, gender: Int?, city: Int?, birthday: Date?)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditProfile{
            emailTextField.isEnabled = false
            emailTextField.textColor = .gray
            nameTextField.text = userInfo!.name!
            emailTextField.text = userInfo!.email!
            genderTextField.text = genders[userInfo!.gender!]
            cityTextField.text = cities[userInfo!.city!]
            let dateFormatter = DateFormatter()
            userInfo!.birthday = userInfo!.birthday!
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            birthdayTextField.text = dateString
            datePicker.date = userInfo!.birthday!
            genderPicker.selectRow(userInfo!.gender!, inComponent: 0, animated: false)
            cityPicker.selectRow(userInfo!.city!, inComponent: 0, animated: false)
            signupButton.setTitle("Update Profile", for: .normal)
        }
        else{
            userInfo = ("", "", 0, 0, nil)
            emailTextField.textColor = .mainOrange
        }
        hidesKeyboardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signupButton.layer.cornerRadius = signupButton.frame.size.height / 2
    }
    
    @objc func keyboardWillShow(){
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin = CGPoint(x: 0, y: -self.nameTextField.frame.origin.y + 30)
        }
    }
    
    @objc func keyboardWillHide(){
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin = .zero
        }
    }
    
    func signup(){
        //TODO: Signup request
        navigationController!.popViewController(animated: true)
    }

}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    @objc func didSelectDate(_ datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        userInfo!.birthday = datePicker.date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        birthdayTextField.text = dateString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPicker{
            genderTextField.text = genders[row]
            userInfo!.gender = row
        }
        else{
            cityTextField.text = cities[row]
            userInfo!.city = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let label = view as? UILabel{
            label.textColor = .mainOrange
            if pickerView == genderPicker{
                label.text = genders[row]
            }
            else{
                label.text = cities[row]
            }
            label.textAlignment = .center
            return label
        }
        let label = UILabel()
        label.textColor = .mainOrange
        if pickerView == genderPicker{
            label.text = genders[row]
        }
        else{
            label.text = cities[row]
        }
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPicker{
            return genders.count
        }
        return cities.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}
