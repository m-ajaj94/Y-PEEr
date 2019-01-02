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
import FaveButton

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
            likeButtonHeart.frame = likeButton.frame
            likeView.frame = likeButton.frame
        }
    }
    private let spacing: CGFloat = 4
    var post: PostModel!{
        didSet{
            images = post.images!
            layoutIfNeeded()
            likeCountLabel.text = "\(post.totalLikes!)" + " " + "Likes".localized
            mainLabel.text = post.title!
            secondaryLabel.text = post.description!
            likeButtonHeart.setSelected(selected: post.isLiked! == "1", animated: false)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            timeLabel.text = (dateFormatter.date(from: post.createdAt!)! as NSDate).timeAgo()
            likeButtonHeart.setSelected(selected: post.isLiked! == "1", animated: false)
        }
    }
    
    var likeButtonHeart: FaveButton!{
        didSet{
            likeButtonHeart.selectedColor = .mainOrange
            shadowView.addSubview(likeButtonHeart)
            likeButton.isUserInteractionEnabled = false
            likeButton.isHidden = true
            likeView = UIView()
        }
    }
    var likeView: UIView!{
        didSet{
            likeView.isUserInteractionEnabled = true
            likeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressLike)))
            shadowView.addSubview(likeView)
        }
    }
    
    @objc func didPressLike(){
        delegate.didPressLike(at: index)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if likeButtonHeart == nil{
            likeButtonHeart = FaveButton(frame: likeButton.frame, faveIconNormal: UIImage(named: "heart"))
        }
        selectionStyle = .none
        backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(likeStatus(_:)), name: NSNotification.Name("LikeChanged"), object: nil)
        likeButtonHeart.frame = likeButton.frame
        likeView.frame = likeButton.frame
    }
    
    @objc func likeStatus(_ notification: Notification){
        let postID: Int = notification.userInfo!["id"] as! Int
        if post.id! != postID{
            return
        }
        post.isLiked = notification.userInfo!["liked"] as! Bool ? "1" : "0"
        likeCountLabel.text = "\((notification.userInfo!["count"] as! Int))" + " " + "Likes".localized
        let isHere: Bool = notification.userInfo!["here"] != nil
        if notification.userInfo!["liked"] as! Bool{
            likeButtonHeart.setSelected(selected: true, animated: isHere)
        }
        else{
            likeButtonHeart.setSelected(selected: false, animated: isHere)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
        likeButtonHeart.frame = likeButton.frame
        likeView.frame = likeButton.frame
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        likeButtonHeart.frame = likeButton.frame
        likeView.frame = likeButton.frame
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
