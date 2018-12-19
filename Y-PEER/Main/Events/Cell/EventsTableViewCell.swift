//
//  EventsTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/9/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var secondsTitleLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesTitleLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursTitleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var daysTitleLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var counterContainerView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIConImageView: UIImageView!
    @IBOutlet weak var linearView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateContainerView: UIView!{
        didSet{
            dateContainerView.layer.borderWidth = 2
            dateContainerView.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    @IBOutlet weak var circularIndicatorView: UIView!{
        didSet{
            circularIndicatorView.backgroundColor = .white
            circularIndicatorView.layer.borderColor = UIColor.mainOrange.cgColor
            circularIndicatorView.layer.borderWidth = 2
        }
    }
    
    var imageName: String!{
        didSet{
            cellImageView.image = UIImage(named: imageName)
            cellImageView.contentMode = .scaleAspectFill
            cellImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circularIndicatorView.layer.cornerRadius = circularIndicatorView.frame.size.width / 2
        dateContainerView.layer.cornerRadius = dateContainerView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
