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
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
