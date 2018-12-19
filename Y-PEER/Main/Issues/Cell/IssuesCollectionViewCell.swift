//
//  IssuesCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class IssuesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    var issue: IssueModel!{
        didSet{
            cellLabel.text = issue.title!
            if issue.images!.count != 0{
                cellImage.kf.setImage(with: Networking.getImageURL(issue.images![0].imagePath!))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }

}
