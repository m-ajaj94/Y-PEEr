//
//  CoreTeamPopupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class CoreTeamPopupViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var member: CoreMemberModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: Networking.getImageURL(member.imageURL!))
        nameLabel.text = member.name!
        descriptionLabel.text = member!.description!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = (UIScreen.main.bounds.width * 0.8 - 128) / 2
    }
    
}
