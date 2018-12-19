//
//  SignViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/10/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class SigninViewController: UIViewController {

    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!{
        didSet{
            textFieldTopConstraint.constant = -44
        }
    }
    @IBOutlet weak var skipButton: UIButton!{
        didSet{
            skipButton.layer.borderWidth = 1
            skipButton.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    @IBOutlet weak var forgotPasswordButton: UIButton!{
        didSet{
            forgotPasswordButton.alpha = 0
        }
    }
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            signupButton.layer.borderWidth = 1
            signupButton.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    @IBOutlet weak var continueButton: UIButton!
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
                let alert = UIAlertController(title: "New Password".localized, message: "We are about to send a new password to \(emailTextField.text!)\nAre you sure?".localized, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes".localized, style: .default) { (action) in
                    
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
                Toast(text: "Error Message TODO".localized).show()
            }
        }
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
