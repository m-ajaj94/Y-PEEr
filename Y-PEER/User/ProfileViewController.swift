//
//  ProfileViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class ProfileViewController: ParentViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var birthdayImageView: UIImageView!
    @IBOutlet weak var birthdayTitleLabel: UILabel!{
        didSet{
            birthdayTitleLabel.text = "Birthday".localized
        }
    }
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTitleLabel: UILabel!{
        didSet{
            locationTitleLabel.text = "City".localized
        }
    }
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var genderTitleLabel: UILabel!{
        didSet{
            genderTitleLabel.text = "Gender".localized
        }
    }
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signoutButton: UIButton!{
        didSet{
            signoutButton.setTitle("Sign out".localized, for: .normal)
            signoutButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            signoutButton.layer.shadowRadius = 5
            signoutButton.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet var containerViews: [UIView]!
    
    @IBAction func didPressSignout(_ sender: Any) {
        let alert = UIAlertController(title: "Sign out".localized, message: "Are you sure?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes".localized, style: .destructive) { (action) in
            UserCache.signout()
            NotificationCenter.default.post(name: NSNotification.Name("Signout"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func didPressDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        let controller = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        controller.delegate = self
        controller.cities = cities
        controller.isEditProfile = true
        navigationController!.pushViewController(controller, animated: true)
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var genders: [String] = ["Male".localized, "Female".localized]
    var user = UserCache.userData!
    var cities: [CityModel]!{
        didSet{
            locationLabel.text = "\(cities[user.cityID! - 1].name!)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for containerView in containerViews{
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            containerView.layer.shadowRadius = 6
            containerView.layer.shadowOpacity = 0.2
        }
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        navigationController!.interactivePopGestureRecognizer?.delegate = nil
        emailLabel.text = user.email!
        nameLabel.text = user.name!
        birthdayLabel.text = user.birthdate!
        genderLabel.text = genders[user.gender!]
        if Cache.cities.cities.count == 0{
            getCities()
        }
        else{
            cities = Cache.cities.cities
        }
        borderView.layer.cornerRadius = borderView.frame.width / 2
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.mainGray.cgColor
        if UserCache.userData.gender! == 0{
            userImageView.image = UIImage(named: "person")
        }
        else{
            userImageView.image = UIImage(named: "girl")
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
                self.showNoConnection(below: self.closeButton)
            }
        }
    }

}

extension ProfileViewController: ProfileViewControllerDelegate{
    func didChangeProfile() {
        user = UserCache.userData
        emailLabel.text = user.email!
        nameLabel.text = user.name!
        birthdayLabel.text = user.birthdate!
        genderLabel.text = genders[user.gender!]
        if Cache.cities.cities.count == 0{
            getCities()
        }
        else{
            cities = Cache.cities.cities
        }
        if UserCache.userData.gender! == 0{
            userImageView.image = UIImage(named: "person")
        }
        else{
            userImageView.image = UIImage(named: "girl")
        }
    }
}

protocol ProfileViewControllerDelegate{
    func didChangeProfile()
}
