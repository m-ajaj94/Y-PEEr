//
//  ProfileViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var birthdayImageView: UIImageView!
    @IBOutlet weak var birthdayTitleLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signoutButton: UIButton!
    
    @IBAction func didPressSignout(_ sender: Any) {
        UserCache.setLoggedIn(false)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        let controller = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        controller.isEditProfile = true
        controller.userInfo = (name: "Majd Ajaj", email: "m.ajaj94@gmail.com", 1, 2, Date())
        navigationController!.pushViewController(controller, animated: true)
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.interactivePopGestureRecognizer?.delegate = nil
    }

}
