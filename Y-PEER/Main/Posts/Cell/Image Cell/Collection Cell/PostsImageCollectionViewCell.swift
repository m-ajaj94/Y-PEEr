//
//  PostsImageCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/8/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class PostsImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
