//
//  PostsUpcomingEventTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/8/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class PostsUpcomingEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var secondsTitleLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesTitleLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursTitleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var daysTitleLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.isUserInteractionEnabled = true
            cellImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage)))
        }
    }
    @IBOutlet weak var shadowView: UIView!{
        didSet{
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowRadius = 3
            shadowView.layer.shadowOpacity = 0.2
        }
    }
    
    var post: PostModel!{
        didSet{
            if post.images!.count != 0{
                cellImage.kf.setImage(with: Networking.getImageURL(post.images![0].imagePath!))
            }
            mainLabel.text = post.title!
            secondaryLabel.text = post.description!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            timeLabel.text = (dateFormatter.date(from: post.createdAt!)! as NSDate).timeAgo()
            likeCountLabel.text = "\(post.totalLikes!)"
            if post.isLiked! == "1"{
                self.likeButton.setTitle("😍", for: .normal)
            }
            else{
                self.likeButton.setTitle("😀", for: .normal)
                
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        delegate.didPressLike(at: index)
    }
    
    var date: Date!
    var delegate: PostsUpcomingEventTableViewCellDelegate!
    var index: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        date = Date(timeIntervalSinceNow: TimeInterval(1000000))
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(shouldUpdateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        NotificationCenter.default.addObserver(self, selector: #selector(likeStatus(_:)), name: NSNotification.Name("LikeChanged"), object: nil)
    }
    
    @objc func likeStatus(_ notification: Notification){
        let postID: Int = notification.userInfo!["id"] as! Int
        if post.id! != postID{
            return
        }
        likeCountLabel.text = "\((notification.userInfo!["count"] as! Int))"
        if notification.userInfo!["liked"] as! Bool{
            likeButton.setTitle("😍", for: .normal)
        }
        else{
            likeButton.setTitle("😀", for: .normal)
        }
    }
    
    @objc func shouldUpdateTime(){
        let now = Date()
        let dif = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
        daysLabel.text = "\(dif.day!)"
        hoursLabel.text = "\(dif.hour!)"
        minutesLabel.text = "\(dif.minute!)"
        secondsLabel.text = "\(dif.second!)"
    }
    
    @objc func didTapImage(){
        delegate.didTapImage(at: index)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

protocol PostsUpcomingEventTableViewCellDelegate{
    func didPressLike(at index: IndexPath)
    func didTapImage(at index: IndexPath)
}
