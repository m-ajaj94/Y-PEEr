//
//  PostDetailsImageCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/14/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class PostDetailsImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.backgroundColor = .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
