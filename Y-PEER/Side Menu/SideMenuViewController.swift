//
//  SideMenuViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/13/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var storiesLabel: UILabel!{
        didSet{
            storiesLabel.text = "Stories".localized
        }
    }
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var userLabel: UILabel!{
        didSet{
            if UserCache.isLoggedIn{
                userLabel.text = UserCache.userData.name!
            }
            else{
                userLabel.text = "Sign in/Register".localized
            }
        }
    }
    @IBOutlet weak var storiesImageView: UIImageView!
    @IBOutlet weak var storiesContainerView: UIView!{
        didSet{
            storiesContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStories)))
        }
    }
    @IBOutlet weak var userContainerView: UIView!{
        didSet{
            userContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUser)))
        }
    }
    @IBOutlet weak var settingsContainerView: UIView!{
        didSet{
            settingsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSettings)))
        }
    }
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!{
        didSet{
            settingsLabel.text = "Settings".localized
        }
    }
    @IBOutlet weak var aboutContainerView: UIView!{
        didSet{
            aboutContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAboutUs)))
        }
    }
    @IBOutlet weak var aboutImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!{
        didSet{
            aboutLabel.text = "About Y-PEER".localized
        }
    }
    @IBOutlet weak var searchContainerView: UIView!{
        didSet{
            searchContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSearch)))
        }
    }
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!{
        didSet{
            searchLabel.text = "Search".localized
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    
    var delegate: SideMenuViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserCache.isLoggedIn{
            userLabel.text = UserCache.userData.name!
        }
        else{
            userLabel.text = "Sign in/Register".localized
        }
        if UserCache.isLoggedIn{
            borderView.layer.borderWidth = 2
            borderView.layer.borderColor = UIColor.mainGray.cgColor
            if UserCache.userData.gender! == 0{
                userImageView.image = UIImage(named: "person")
            }
            else{
                userImageView.image = UIImage(named: "girl")
            }
        }
        else{
            borderView.layer.borderWidth = 0
            userImageView.image = UIImage(named: "user")
        }
    }
    
    @objc func didTapSettings(){
        dismiss(animated: true, completion: nil)
        delegate.didSelectSettings()
    }
    
    @objc func didTapAboutUs(){
        dismiss(animated: true, completion: nil)
        delegate.didSelectAboutUs()
    }
    
    @objc func didTapSearch(){
        dismiss(animated: true, completion: nil)
        delegate.didSelectSearch()
    }
    
    @objc func didTapUser(){
        dismiss(animated: true, completion: nil)
        delegate.didSelectUser()
    }
    
    @objc func didTapStories(){
        dismiss(animated: true, completion: nil)
        delegate.didSelectStories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        borderView.layer.cornerRadius = borderView.frame.width / 2
        settingsContainerView.layer.cornerRadius = settingsContainerView.frame.size.height / 2
        settingsImageView.layer.cornerRadius = settingsImageView.frame.size.height / 2
        aboutContainerView.layer.cornerRadius = aboutContainerView.frame.size.height / 2
        aboutImageView.layer.cornerRadius = aboutImageView.frame.size.height / 2
        searchContainerView.layer.cornerRadius = searchContainerView.frame.size.height / 2
        searchImageView.layer.cornerRadius = searchImageView.frame.size.height / 2
        storiesImageView.layer.cornerRadius = storiesImageView.frame.size.height / 2
        storiesContainerView.layer.cornerRadius = storiesContainerView.frame.size.height / 2
    }

}

protocol SideMenuViewControllerDelegate{
    func didSelectSettings()
    func didSelectAboutUs()
    func didSelectSearch()
    func didSelectUser()
    func didSelectStories()
}
