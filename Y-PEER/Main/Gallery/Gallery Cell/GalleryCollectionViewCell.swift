//
//  GalleryCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoIcon: UIImageView!{
        didSet{
            videoIcon.isHidden = true
        }
    }
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
