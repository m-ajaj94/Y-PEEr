//
//  SearchResultsTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/3/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 4
            containerView.layer.shadowRadius = 3
            containerView.layer.shadowOpacity = 0.1
            containerView.layer.shadowColor = UIColor.black.cgColor
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
}
