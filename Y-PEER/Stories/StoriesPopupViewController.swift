//
//  StoriesPopupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class StoriesPopupViewController: ParentViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What are stories?".localized
        descriptionLabel.text = "stories explanation".localized
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width / 2
    }

}
