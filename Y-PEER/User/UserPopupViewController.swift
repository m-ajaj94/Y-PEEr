//
//  UserPopupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class UserPopupViewController: ParentViewController {

    @IBOutlet weak var imageContainerView: UIView!{
        didSet{
            imageContainerView.layer.shadowOffset = .zero
            imageContainerView.layer.shadowColor = UIColor.gray.cgColor
            imageContainerView.layer.shadowOpacity = 0.3
            imageContainerView.layer.shadowRadius = 3
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
        }
    }
    
    var delegate: UserPopupViewControllerDelegate!
    var username: String!
    var email: String!
    var isPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPassword{
            titleLabel.text = "New Password".localized
            descriptionLabel.text = "A new password has been sent to".localized + " " + email + "\n" + "Please check your E-mail, and use your new password to sign in".localized
            imageView.image = UIImage(named: "key.png")
        }
        else{
            titleLabel.text = "Welcome".localized + " " + username
            descriptionLabel.text = "sign up description".localized + "\n" + "A new password has been sent to".localized + " " + email + "\n" + "Please check your E-mail, and use your new password to sign in".localized
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !isPassword{
            delegate.didDismiss()
        }
    }

}

protocol UserPopupViewControllerDelegate{
    func didDismiss()
}
