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
    @IBOutlet weak var titleLabel: UILabel!
    
    var event: EventDataModel!{
        didSet{
            if event.images!.count != 0{
                cellImageView.kf.setImage(with: Networking.getImageURL(event.images![0].thumbnailPath!))
            }
            if event.location != nil{
                locationLabel.text = event.location!
            }
            dateLabel.text = event.startDate!
            titleLabel.text = event.title!
            if type == PostType.pastEvent{
                daysTitleLabel.text = "Likes".localized
                hoursTitleLabel.text = "Views".localized
                minutesTitleLabel.text = "Media".localized
                secondsTitleLabel.isHidden = true
                secondsLabel.isHidden = true
                minutesLabel.text = "\(event.images!.count)"
                hoursLabel.text = "\(event.totalViews!)"
                daysLabel.text = "\(event.totalLikes!)"
            }
            else{
                daysTitleLabel.text = "Days".localized
                hoursTitleLabel.text = "Hours".localized
                minutesTitleLabel.text = "Minutes".localized
                secondsTitleLabel.text = "Seconds".localized
                secondsTitleLabel.isHidden = false
                secondsLabel.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                date = dateFormatter.date(from: event.startDate! + " " + event.startTime!)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let timer = Timer(timeInterval: 1, target: self, selector: #selector(shouldUpdateTime), userInfo: nil, repeats: true)
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    var date: Date!
    
    
    @objc func shouldUpdateTime(){
        let now = Date()
        let dif = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
        daysLabel.text = "\(dif.day!)"
        hoursLabel.text = "\(dif.hour!)"
        minutesLabel.text = "\(dif.minute!)"
        secondsLabel.text = "\(dif.second!)"
    }
    
    var type: PostType!
    
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
