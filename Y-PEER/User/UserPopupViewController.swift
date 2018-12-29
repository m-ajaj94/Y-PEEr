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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Welcome".localized + " " + username
        descriptionLabel.text = "sign up description".localized
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate.didDismiss()
    }

}

protocol UserPopupViewControllerDelegate{
    func didDismiss()
}
