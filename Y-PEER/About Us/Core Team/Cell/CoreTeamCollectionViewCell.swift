//
//  CoreTeamCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/24/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class CoreTeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowRadius = 6
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.cornerRadius = 4
            containerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.backgroundColor = .mainOrange
        }
    }
    @IBOutlet weak var cellLabel: UILabel!
    var member: CoreMemberModel!{
        didSet{
            cellImage.kf.setImage(with: Networking.getImageURL(member.imageURL!))
            cellLabel.text = member.name!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewWidth = ((UIScreen.main.bounds.width - (16 * 4)) / 2) - 24
        cellImage.layer.cornerRadius = imageViewWidth / 2
    }

}
