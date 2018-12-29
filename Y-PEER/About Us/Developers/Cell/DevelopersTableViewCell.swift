//
//  DevelopersTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class DevelopersTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 0.3
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var cellImageView: UIImageView!{
        didSet{
            cellImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func facebookButtonPressed(_ sender: Any) {
        UIApplication.shared.open(facebookLink, options: [:], completionHandler: nil)
    }
    @IBAction func linkedinButtonPressed(_ sender: Any) {
        UIApplication.shared.open(linkdinLink, options: [:], completionHandler: nil)
    }
    
    var facebookLink: URL!
    var linkdinLink: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageView.layer.cornerRadius = cellImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
