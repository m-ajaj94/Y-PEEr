//
//  SignupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/10/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class SignupViewController: ParentViewController {

    @IBOutlet weak var backButton: UIButton!{
        didSet{
            if Cache.language.current == .arabic{
                backButton.flipX()
            }
        }
    }
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
                if selectedGender == nil || selectedGender == 0{
                    showErrorAlert("Please select your gender!".localized)
                }
                else{
                    if selectedCity == nil || selectedCity == 0{
                        showErrorAlert("Please select your city!".localized)
                    }
                    else{
                        if selectedBirthday == nil{
                            showErrorAlert("Please enter your birthday!".localized)
                        }
                        else{
                            if isEditProfile{
                                updateProfile()
                            }
                            else{
                                signup()
                            }
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
    var cities: [CityModel]!
    var datePicker: UIDatePicker!{
        didSet{
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
            datePicker.datePickerMode = .date
        }
    }
    var genderPicker, cityPicker: UIPickerView!
    var isEditProfile = false
    var user: SigninModel!
    var selectedGender: Int!
    var selectedCity: Int!
    var selectedBirthday: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        if isEditProfile{
            user = UserCache.userData!
            emailTextField.isEnabled = false
            emailTextField.textColor = .gray
            nameTextField.text = user.name!
            emailTextField.text = user.email!
            genderTextField.text = genders[user.gender!]
            cityTextField.text = cities![user.cityID! - 1].name!
            selectedCity = user.cityID! - 1
            selectedGender = user.gender!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let birthday = dateFormatter.date(from: user.birthdate!)!
            selectedBirthday = birthday
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: birthday)
            birthdayTextField.text = dateString
            datePicker.date = birthday
            genderPicker.selectRow(user.gender!, inComponent: 0, animated: false)
            cityPicker.selectRow(user.cityID!, inComponent: 0, animated: false)
            signupButton.setTitle("Update Profile", for: .normal)
        }
        hidesKeyboardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if cities == nil{
            getCities()
        }
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
    
    func updateProfile(){
        var dict: [String:Any] = [:]
        dict["username"] = nameTextField.text!
        dict["gender"] = selectedGender
        dict["email"] = emailTextField.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dict["birthdate"] = dateFormatter.string(from: selectedBirthday)
        dict["cityId"] = selectedCity + 1
        dict["user_id"] = UserCache.userID
        Networking.user.updateProfile(dict) { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.navigationController!.popViewController(animated: true)
                    Toast(text: model!.message).show()
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "Error Message TODO".localized).show()
            }
        }
    }
    
    func signup(){
        var dict: [String:Any] = [:]
        dict["username"] = nameTextField.text!
        dict["gender"] = selectedGender
        dict["email"] = emailTextField.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dict["birthdate"] = dateFormatter.string(from: selectedBirthday)
        dict["cityId"] = selectedCity + 1
        Networking.user.signup(dict) { (model) in
            if model != nil{
                Toast(text: model!.message).show()
                if model!.code == "1"{
                    self.navigationController!.popViewController(animated: true)
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "Error Message TODO".localized).show()
            }
        }
//
    }
    
    
    override func didPressRetry() {
        removeNoConnection()
        getCities()
    }
    
    func getCities(){
        showLoading()
        Networking.getCities { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.cities = model!.data!
                }
                else{
                    Toast(text: model!.message!).show()
                }
            }
            else{
                self.showNoConnection(below: self.backButton)
            }
        }
    }

}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    @objc func didSelectDate(_ datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        selectedBirthday = datePicker.date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        birthdayTextField.text = dateString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPicker{
            genderTextField.text = genders[row]
            selectedGender = row
        }
        else{
            cityTextField.text = cities[row].name!
            selectedCity = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let label = view as? UILabel{
            label.textColor = .mainOrange
            if pickerView == genderPicker{
                label.text = genders[row]
            }
            else{
                label.text = cities[row].name!
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
            label.text = cities[row].name!
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

