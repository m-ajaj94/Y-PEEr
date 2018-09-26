//
//  AboutDetailsTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class AboutDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
