//
//  SignupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/10/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster
import Presentr

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
                if selectedGender == nil{
                    showErrorAlert("Please select your gender!".localized)
                }
                else{
                    if selectedCity == nil{
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
    
    var delegate: ProfileViewControllerDelegate!
    var genders = ["Male".localized, "Female".localized]
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
    var selectedGender: Int! = 0
    var selectedCity: Int! = 0
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
            emailTextField.textColor = .mainGray
            emailTextField.layoutSubviews()
            nameTextField.text = user.name!
            emailTextField.text = user.email!
            selectedCity = user.cityID! - 1
            cityTextField.text = cities![user.cityID! - 1].name!
            selectedGender = user.gender!
            genderTextField.text = genders[user.gender!]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let birthday = dateFormatter.date(from: user.birthdate!)!
            selectedBirthday = birthday
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: birthday)
            birthdayTextField.text = dateString
            datePicker.date = birthday
            genderPicker.selectRow(user.gender!, inComponent: 0, animated: false)
            cityPicker.selectRow(user.cityID!-1, inComponent: 0, animated: false)
            signupButton.setTitle("Update Profile", for: .normal)
        }
        else{
            if Cache.cities.cities.count == 0{
                getCities()
            }
            else{
                cities = Cache.cities.cities
                cityTextField.text = cities[0].name!
            }
            genderTextField.text = genders[0]
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
            self.view.frame.origin = CGPoint(x: 0, y: -self.nameTextField.frame.origin.y + 48)
        }
    }
    
    @objc func keyboardWillHide(){
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin = .zero
        }
    }
    
    func updateProfile(){
        showLoading()
        var dict: [String:Any] = [:]
        dict["name"] = nameTextField.text!
        dict["gender"] = selectedGender
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dict["birthdate"] = dateFormatter.string(from: selectedBirthday)
        dict["city_id"] = selectedCity + 1
        dict["user_id"] = UserCache.userID
        Networking.user.updateProfile(dict) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    UserCache.signin(model!.data![0])
                    self.delegate.didChangeProfile()
                    self.navigationController!.popViewController(animated: true)
                    Toast(text: model!.message).show()
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "ERROR CONNECT MESSAGE".localized).show()
            }
        }
    }
    
    func signup(){
        showLoading()
        var dict: [String:Any] = [:]
        dict["username"] = nameTextField.text!
        dict["gender"] = selectedGender
        dict["email"] = emailTextField.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dict["birthdate"] = dateFormatter.string(from: selectedBirthday)
        dict["cityId"] = selectedCity + 1
        Networking.user.signup(dict) { (model) in
            self.removeLoading()
            if model != nil{
                Toast(text: model!.message).show()
                if model!.code == "1"{
                   self.showPopup()
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "ERROR CONNECT MESSAGE".localized).show()
            }
        }
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
    
    let presenter: Presentr = {
        let width = ModalSize.custom(size: Float(UIScreen.main.bounds.width * 0.8))
        let height = ModalSize.custom(size: Float(UIScreen.main.bounds.height * 0.5))
        let center = ModalCenterPosition.center//custom(centerPoint: CGPoint(x: view.center.x, y: view.center.y - 44))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 10
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.4
        return customPresenter
    }()
    
    func showPopup(){
        let controller = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: String(describing: UserPopupViewController.self)) as! UserPopupViewController
        controller.username = nameTextField.text!
        controller.delegate = self
        customPresentViewController(presenter, viewController: controller, animated: true)
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

extension SignupViewController: UserPopupViewControllerDelegate{
    func didDismiss() {
        self.navigationController!.popViewController(animated: true)
    }
}
