//
//  StoriesTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/28/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class StoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!{
        didSet{
            shadowView.layer.cornerRadius = 16
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowRadius = 5
            shadowView.layer.shadowOpacity = 0.3
        }
    }
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
            userImageView.layer.borderWidth = 3
            userImageView.layer.borderColor = UIColor.mainGray.cgColor
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    
    var story: StoryModel!{
        didSet{
            if story.nameVisibility == 1{
                nameLabel.text = story.username!.name!
            }
            else{
                nameLabel.text = "Anonymous".localized
            }
            storyLabel.text = story.story!
            issueLabel.text = story.issueName!.title!
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
