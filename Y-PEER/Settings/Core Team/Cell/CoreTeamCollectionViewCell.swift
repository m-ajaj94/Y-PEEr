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
            containerView.layer.shadowRadius = 2
            containerView.layer.shadowOpacity = 0.4
            containerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.backgroundColor = .mainOrange
            cellImage.layer.cornerRadius = cellImage.frame.width / 2
        }
    }
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImage.layer.cornerRadius = cellImage.frame.width / 2
    }

}
