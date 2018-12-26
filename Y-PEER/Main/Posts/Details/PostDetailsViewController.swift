//
//  PostDetailsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/13/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import FlexiblePageControl
import Toaster

class PostDetailsViewController: ParentViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.bounces = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(UINib(nibName: String(describing: PostDetailsImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PostDetailsImageCollectionViewCell.self))
        }
    }
    @IBOutlet weak var likesCotinerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
        if UserCache.isLoggedIn{
            if post.isLiked! == "0"{
                Networking.posts.likePost(["post_id":post.id!,"user_id":UserCache.userID]) { (model) in
                    if model != nil && model!.code! == "1"{
                        self.post.isLiked = "1"
                        self.post.totalLikes = model!.data!.likesCount!
                        self.likesCountLabel.text = "\(model!.data!.likesCount!)"
                        self.likeButton.setTitle("😍", for: .normal)
                        NotificationCenter.default.post(name: NSNotification.Name("LikeChanged"), object: nil, userInfo: ["id":self.post.id!,"count":model!.data!.likesCount!, "liked":true])
                    }
                    else{
                        if model == nil{
                            Toast(text: "Error Message").show()
                        }
                        else{
                            Toast(text: model!.message!).show()
                        }
                    }
                }
            }
            else{
                Networking.posts.dislikePost(["post_id":post.id!,"user_id":UserCache.userID]) { (model) in
                    if model != nil && model!.code! == "1"{
                        self.post.isLiked = "1"
                        self.post.totalLikes = model!.data!.likesCount!
                        self.likesCountLabel.text = "\(model!.data!.likesCount!)"
                        self.likeButton.setTitle("😀", for: .normal)
                        NotificationCenter.default.post(name: NSNotification.Name("LikeChanged"), object: nil, userInfo: ["id":self.post.id!,"count":model!.data!.likesCount!, "liked":false])
                    }
                    else{
                        if model == nil{
                            Toast(text: "Error Message").show()
                        }
                        else{
                            Toast(text: model!.message!).show()
                        }
                    }
                }
            }
        }
        else{
            let navController = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let controller = navController.viewControllers[0] as! SigninViewController
            controller.isModal = true
            present(navController, animated: true, completion: nil)
        }
    }
    
    var noImages = false
    var passedImages: [String]!
    var images: [ImageModel]!{
        didSet{
            if images == nil || images.count == 0{
                noImages = true
            }
            else{
                heightConstraint.constant = height
                pageControl.isHidden = images.count <= 1
                pageControl.numberOfPages = images.count
            }
            view.layoutIfNeeded()
        }
    }
    var post: PostModel!{
        didSet{
        }
    }
    let height = UIScreen.main.bounds.width * 3 / 5
    var pageControl: FlexiblePageControl!{
        didSet{
            pageControl.center = collectionView.center
            pageControl.pageIndicatorTintColor = .mainGray
            pageControl.currentPageIndicatorTintColor = .mainOrange
            scrollView.addSubview(pageControl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstraint.constant = height
        title = "Post"
        pageControl = FlexiblePageControl()
        titleLabel.text = post.title!
        descriptionLabel.text = post.description!
        likesCountLabel.text = "\(post.totalLikes!)"
        images = post.images!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = (dateFormatter.date(from: post.createdAt!)! as NSDate).timeAgo()
        if post.isLiked! == "1"{
            self.likeButton.setTitle("😍", for: .normal)
        }
        else{
            self.likeButton.setTitle("😀", for: .normal)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame.origin = CGPoint(x: view.frame.midX - pageControl.frame.size.width / 2, y: collectionView.frame.origin.y + height - pageControl.frame.size.height)
        collectionView.reloadData()
    }
}

extension PostDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostDetailsImageCollectionViewCell.self), for: indexPath) as? PostDetailsImageCollectionViewCell{
            cell.cellImage.kf.setImage(with: Networking.getImageURL(images[indexPath.row].thumbnailPath!))
            cell.blurredImageView.kf.setImage(with: Networking.getImageURL(images[indexPath.row].thumbnailPath!))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if noImages{
            return
        }
        showImages(images, indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}

extension PostDetailsViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
            if images != nil && images.count != 0{
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: max(scrollView.contentOffset.y, 0))
            }
        }
        else{
            pageControl.setCurrentPage(at: Int(collectionView.contentOffset.x / collectionView.frame.size.width))
        }
    }
    
}
