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
    @IBOutlet var containerViews: [UIView]!
    
    @IBAction func didPressSignout(_ sender: Any) {
        UserCache.signout()
        dismiss(animated: true, completion: nil)
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
            containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
            containerView.layer.shadowRadius = 3
            containerView.layer.shadowOpacity = 0.2
        }
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
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
    }
}

protocol ProfileViewControllerDelegate{
    func didChangeProfile()
}
