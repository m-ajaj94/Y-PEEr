//
//  SideMenuViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/13/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var settingsContainerView: UIView!{
        didSet{
            settingsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:     #selector(didTapSettings)))
        }
    }
    
    var delegate: SideMenuViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func didTapSettings(){
        delegate.didSelectSettings()
    }

}

protocol SideMenuViewControllerDelegate{
    func didSelectSettings()
}
