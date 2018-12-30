//
//  PostImageTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/8/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Kingfisher
import NSDate_TimeAgo

class PostImageTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isScrollEnabled = false
            collectionView.register(UINib(nibName: String(describing: PostsImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PostsImageCollectionViewCell.self))
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
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        delegate.didPressLike(at: index)
    }
    
    var delegate: PostImageTableViewCellDelegate!
    var index: IndexPath!
    var images: [ImageModel]!{
        didSet{
            collectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            switch images.count {
            case 0:
                collectionViewHeightConstraint.constant = 0
            case 1:
                collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.width * 3 / 5
                break
            case 2:
                collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.width * 1 / 2
                break
            default:
                collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.width
            }
            layoutIfNeeded()
        }
    }
    private let spacing: CGFloat = 4
    var post: PostModel!{
        didSet{
            images = post.images!
            layoutIfNeeded()
            if post.totalLikes != nil{
                likeCountLabel.text = "\(post.totalLikes!)"
            }
            if post.isLiked != nil{
                if post.isLiked! != "0"{
                    //TODO: Like Status
                }
            }
            mainLabel.text = post.title!
            secondaryLabel.text = post.description!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            timeLabel.text = (dateFormatter.date(from: post.createdAt!)! as NSDate).timeAgo()
            if post.isLiked! == "1"{
                self.likeButton.setTitle("😍", for: .normal)
            }
            else{
                self.likeButton.setTitle("😀", for: .normal)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension PostImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostsImageCollectionViewCell.self), for: indexPath) as? PostsImageCollectionViewCell{
            let url = Networking.getImageURL(images[indexPath.row].thumbnailPath!)
            cell.cellImage.kf.setImage(with: url)
            if indexPath.row == 3 && images.count > 4{
                cell.blurView.isHidden = false
                cell.countLabel.text = "+\(images.count - 4)"
            }
            else{
                cell.blurView.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch images.count {
        case 1:
            return CGSize(width: UIScreen.main.bounds.size.width - spacing * 2, height: (UIScreen.main.bounds.size.width - spacing * 2) * 3 / 5)
        case 2:
            let width = (UIScreen.main.bounds.size.width - (3 * spacing)) / 2
            return CGSize(width: width, height: width)
        case 3:
            let width = (UIScreen.main.bounds.size.width - (3 * spacing)) / 2
            let height = (UIScreen.main.bounds.size.width - spacing * 3) / 2
            switch indexPath.row{
            case 0:
                return CGSize(width: UIScreen.main.bounds.size.width, height: height)
            case 1:
                return CGSize(width: width, height: height)
            case 2:
                return CGSize(width: width, height: height)
            default:
                return .zero
            }
        default:
            let width = (UIScreen.main.bounds.size.width - (3 * spacing)) / 2
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.didSeletImage(at: indexPath, from: index)
    }
    
}

protocol PostImageTableViewCellDelegate{
    func didPressLike(at index: IndexPath)
    func didSeletImage(at index: IndexPath, from originalIndex: IndexPath)
}
