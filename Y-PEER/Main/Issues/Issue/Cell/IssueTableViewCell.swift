//
//  IssueTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var mainContainerView: UIView!{
        didSet{
            mainContainerView.layer.shadowOpacity = 0.4
            mainContainerView.layer.shadowRadius = 3
            mainContainerView.layer.shadowOffset = .zero
            mainContainerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.contentMode = .scaleAspectFill
            cellImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var article: ArticleModel!{
        didSet{
            if Cache.language.current == .arabic{
                cellTitleLabel.text = article.titleAr!
            }
            else{
                cellTitleLabel.text = article.titleEn!
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateLabel.text = (dateFormatter.date(from: article.createdAt!)! as NSDate).timeAgo()
            cellImage.kf.setImage(with: Networking.getImageURL(article.images![0].imagePath!))
        }
    }
    
    var imageName: String!{
        didSet{
            cellImage.image = UIImage(named: imageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
