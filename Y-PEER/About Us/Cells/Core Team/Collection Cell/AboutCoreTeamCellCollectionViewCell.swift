//
//  AboutCoreTeamCellCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/23/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class AboutCoreTeamCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!{
        didSet{
        }
    }
    @IBOutlet weak var cellImageView: UIImageView!{
        didSet{
            cellImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageView.layer.cornerRadius = 15
        shadowView.layer.cornerRadius = 15
    }

}
