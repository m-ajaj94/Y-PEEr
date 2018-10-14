//
//  SideMenuViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/13/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!{
        didSet{
            if UserCache.isLoggedIn{
                userLabel.text = "Majd Ajaj"
            }
            else{
                userLabel.text = "Sign in/Register"
            }
        }
    }
    @IBOutlet weak var userContainerView: UIView!{
        didSet{
            layer.frame.size = userContainerView.frame.size
            layer.frame.origin = CGPoint(x: 0, y: 0)
            layer.cornerRadius = 0
            layer.endPoint = CGPoint(x: 1, y: 0)
            let firstColor = UIColor.white.cgColor
            let secondColor = UIColor.mainOrange.cgColor
            layer.colors = [firstColor, secondColor]
            userContainerView.layer.insertSublayer(layer, at: 0)
            userContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUser)))
        }
    }
    @IBOutlet weak var settingsContainerView: UIView!{
        didSet{
            settingsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSettings)))
        }
    }
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var aboutContainerView: UIView!{
        didSet{
            aboutContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAboutUs)))
        }
    }
    @IBOutlet weak var aboutImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var searchContainerView: UIView!{
        didSet{
            searchContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSearch)))
        }
    }
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    
    var delegate: SideMenuViewControllerDelegate!
    let layer : CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserCache.isLoggedIn{
            userLabel.text = "Majd Ajaj"
        }
        else{
            userLabel.text = "Sign in/Register"
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsContainerView.layer.cornerRadius = settingsContainerView.frame.size.height / 2
        settingsImageView.layer.cornerRadius = settingsImageView.frame.size.height / 2
        aboutContainerView.layer.cornerRadius = aboutContainerView.frame.size.height / 2
        aboutImageView.layer.cornerRadius = aboutImageView.frame.size.height / 2
        searchContainerView.layer.cornerRadius = searchContainerView.frame.size.height / 2
        searchImageView.layer.cornerRadius = searchImageView.frame.size.height / 2
        layer.frame.size = userContainerView.frame.size
    }

}

protocol SideMenuViewControllerDelegate{
    func didSelectSettings()
    func didSelectAboutUs()
    func didSelectSearch()
    func didSelectUser()
}
