//
//  SignViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/10/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster
import Presentr

class SigninViewController: UIViewController {

    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!{
        didSet{
            textFieldTopConstraint.constant = -44
        }
    }
    @IBOutlet weak var skipButton: UIButton!{
        didSet{
            skipButton.setTitle("Skip".localized, for: .normal)
            skipButton.layer.borderWidth = 1
            skipButton.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    @IBOutlet weak var forgotPasswordButton: UIButton!{
        didSet{
            forgotPasswordButton.setTitle("Forgot Password".localized, for: .normal)
            forgotPasswordButton.alpha = 0
        }
    }
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            signupButton.setTitle("Signup".localized, for: .normal)
            signupButton.layer.borderWidth = 1
            signupButton.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    @IBOutlet weak var continueButton: UIButton!{
        didSet{
            continueButton.setTitle("Continue".localized, for: .normal)
        }
    }
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.placeholder = "E-mail".localized
            emailTextField.setLeftPaddingPoints(16)
            emailTextField.setRightPaddingPoints(16)
            emailTextField.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.alpha = 0
            passwordTextField.placeholder = "Password".localized
            passwordTextField.setLeftPaddingPoints(16)
            passwordTextField.setRightPaddingPoints(16)
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBAction func continueButtonPressed(_ sender: Any) {
        if passwordTextFieldShown{
            if emailTextField.empty{
                showErrorAlert("Please enter your e-mail first!".localized)
            }
            else{
                if !emailTextField.text!.isEmail{
                    showErrorAlert("Please enter a valid e-mail!".localized)
                }
                else{
                    if !passwordTextField.empty && passwordTextField.text!.count >= 6{
                        requestData()
                    }
                    else{
                        showErrorAlert("Please enter your password!\nA password must be at least 6 characters long".localized)
                    }
                }
            }
        }
        else{
            if emailTextField.empty{
                showErrorAlert("Please enter your e-mail first!".localized)
            }
            else{
                if !emailTextField.text!.isEmail{
                    showErrorAlert("Please enter a valid e-mail!".localized)
                }
                else{
                    passwordTextFieldShown = true
                    self.textFieldTopConstraint.constant = 16
                    UIView.animate(withDuration: 0.3) {
                        self.passwordTextField.alpha = 1
                        self.forgotPasswordButton.alpha = 1
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if emailTextField.empty{
            showErrorAlert("Please enter your e-mail first!".localized)
        }
        else{
            if !emailTextField.text!.isEmail{
                showErrorAlert("Please enter a valid e-mail!".localized)
            }
            else{
                let alert = UIAlertController(title: "New Password".localized, message: "We are about to send a new password to".localized+" \(emailTextField.text!)\n"+"Are you sure?".localized, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes".localized, style: .default) { (action) in
                    self.forgotRequest()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
                alert.view.tintColor = .mainOrange
                alert.addAction(yesAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func signupButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowSignup", sender: self)
    }
    @IBAction func skipButtonPressed(_ sender: Any) {
        if isModal{
            dismiss(animated: true, completion: nil)
        }
        else{
            UserCache.signout()
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
    }
    
    var passwordTextFieldShown = false
    var isModal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        hidesKeyboardOnTap()
        navigationController!.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func requestData(){
        Networking.user.signin(["email":emailTextField.text!,"password":passwordTextField.text!, "session_id":""]) { (model) in
            if model != nil{
                if model!.code == "1"{
                    UserCache.signin(model!.data!)
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
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
    
    func forgotRequest(){
        showLoading()
        Networking.user.forgotPassword(["email":emailTextField.text!]) { (model) in
            self.removeLoading()
            if model != nil{
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
        controller.isPassword = true
        controller.email = emailTextField.text!
        customPresentViewController(presenter, viewController: controller, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signupButton.layer.cornerRadius = signupButton.frame.size.height / 2
        continueButton.layer.cornerRadius = continueButton.frame.size.height / 2
        skipButton.layer.cornerRadius = skipButton.frame.size.height / 2
    }

}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    var empty: Bool{
        return !((self.text != nil) && (self.text!.count != 0))
    }
}

