//
//  EventDetailsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/14/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import FlexiblePageControl

class EventDetailsViewController: ParentViewController {

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
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
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdTitleLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fourthTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBAction func eventButtonPressed(_ sender: Any) {
        
    }
    
    var noImages = false
    var images: [ImageModel]!{
        didSet{
        }
    }
    var event: EventModel!{
        didSet{
        }
    }
    var eventDetails: EventDataModel!{
        didSet{
            
        }
    }
    let height = UIScreen.main.bounds.width * 3 / 5
    var imageName: String!
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
        if event != nil{
            titleLabel.text = event.title!
            descriptionLabel.text = event.description!
            title = event.title!
            
        }
        else{
            titleLabel.text = eventDetails.title!
            descriptionLabel.text = eventDetails.description!
            images = eventDetails.images!
            title = eventDetails.title!
        }
        pageControl = FlexiblePageControl()
        if images == nil || images.count == 0{
            noImages = true
        }
        else{
            heightConstraint.constant = height
            pageControl.isHidden = images.count <= 1
            pageControl.numberOfPages = images.count
        }
        heightConstraint.constant = height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame.origin = CGPoint(x: view.frame.midX - pageControl.frame.size.width / 2, y: collectionView.frame.origin.y + height - pageControl.frame.size.height)
        collectionView.reloadData()
    }
    
}

extension EventDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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

extension EventDetailsViewController: UIScrollViewDelegate{
    
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
