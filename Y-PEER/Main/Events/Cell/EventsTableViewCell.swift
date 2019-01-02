//
//  EventsTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/9/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import FaveButton

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
    @IBOutlet weak var buttonContainerView: UIView!{
        didSet{
            buttonContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            buttonContainerView.layer.shadowColor = UIColor.gray.cgColor
            buttonContainerView.layer.shadowRadius = 5
            buttonContainerView.layer.shadowOpacity = 0.3
        }
    }
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonPressed(_ sender: Any) {
        delegate.didPressButton(at: index)
    }
    
    var index: IndexPath!
    var delegate: EventsTableViewCellDelegate!
    var event: EventDataModel!{
        didSet{
            setButton()
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
                shouldUpdateTime()
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    var likeButton: FaveButton!{
        didSet{
            likeButton.delegate = self
            likeButton.selectedColor = .mainOrange
            buttonContainerView.addSubview(likeButton)
            likeButton.isUserInteractionEnabled = false
            likeButton.setSelected(selected: event.isLiked! == "1", animated: false)
            addButton.isHidden = true
            likeView = UIView()
        }
    }
    var likeView: UIView!{
        didSet{
            likeView.isUserInteractionEnabled = true
            likeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressLike)))
            buttonContainerView.addSubview(likeView)
        }
    }
    
    func setButton(){
        if event.type! == "passed"{
            if likeButton == nil{
                likeButton = FaveButton(frame: addButton.frame, faveIconNormal: UIImage(named: "heart"))
            }
            else{
                likeButton.isHidden = false
                likeView.isHidden = false
                addButton.isHidden = true
                likeButton.setSelected(selected: event.isLiked! == "1", animated: false)
            }
        }
        else{
            if likeButton != nil{
                likeButton.isHidden = true
                likeView.isHidden = true
                addButton.isHidden = false
            }
        }
    }
    
    @objc func didPressLike(){
        delegate.didPressButton(at: index)
    }
    
    var date: Date!
    
    @objc func shouldUpdateTime(){
        if type != .pastEvent{
            let now = Date()
            let dif = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
            daysLabel.text = "\(dif.day!)"
            hoursLabel.text = "\(dif.hour!)"
            minutesLabel.text = "\(dif.minute!)"
            secondsLabel.text = "\(dif.second!)"
        }
    }
    
    var type: PostType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(likeStatus(_:)), name: NSNotification.Name("EventLikeChanged"), object: nil)
    }
    
    @objc func likeStatus(_ notification: Notification){
        let eventID: Int = notification.userInfo!["id"] as! Int
        if let value = notification.userInfo!["here"] as? Bool{
            if value{
                if eventID == event.id!{
                    event.totalLikes = (notification.userInfo!["count"] as! Int)
                    event.isLiked = (notification.userInfo!["liked"] as! Bool) ? "1" : "0"
                    daysLabel.text = "\(event.totalLikes!)"
                    likeButton.setSelected(selected: event.isLiked! == "1", animated: true)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circularIndicatorView.layer.cornerRadius = circularIndicatorView.frame.size.width / 2
        dateContainerView.layer.cornerRadius = dateContainerView.frame.size.height / 2
        buttonContainerView.layer.cornerRadius = buttonContainerView.frame.width / 2
        if likeButton != nil{
            likeView.frame = addButton.frame
            likeButton.frame = addButton.frame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol EventsTableViewCellDelegate {
    func didPressButton(at index: IndexPath)
}
