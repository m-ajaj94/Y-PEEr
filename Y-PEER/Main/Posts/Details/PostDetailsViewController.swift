//
//  PostDetailsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/13/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import FlexiblePageControl

class PostDetailsViewController: ParentViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.bounces = false
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
    
    var noImages = false
    var images: [String]!{
        didSet{
            if images == nil || images.count == 0{
                images = ["logo"]
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
        title = "Post"
        pageControl = FlexiblePageControl()
//        images = ["a.jpg", "1.png", "a.jpg", "1.png", "a.jpg", "1.png", "a.jpg", "1.png"]
        images = []
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
            cell.cellImage.image = UIImage(named: images[indexPath.row])
            cell.blurredImageView.image = UIImage(named: images[indexPath.row])
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
