//
//  EventDetailsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/14/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import FaveButton
import Toaster
import ISPageControl

class EventDetailsViewController: ParentViewController, FaveButtonDelegate {
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
    }
    

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
        if !UserCache.isLoggedIn{
            let navController = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let controller = navController.viewControllers[0] as! SigninViewController
            controller.isModal = true
            present(navController, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "ShowForm", sender: self)
        }
    }
    
    var type: PostType!
    var noImages = false
    var images: [ImageModel]!{
        didSet{
        }
    }
    var event: EventDataModel!{
        didSet{
            
        }
    }
    let height = UIScreen.main.bounds.width * 3 / 5
    var imageName: String!
    var pageControl: ISPageControl!{
        didSet{
            pageControl.currentPageTintColor = .mainOrange
            pageControl.inactiveTintColor = .white
            pageControl.radius = 3
            pageControl.inactiveTransparency = 1
            pageControl.numberOfPages = images.count
            if Cache.language.current == .arabic{
                pageControl.currentPage = images.count - 1
            }
            pageControl.isHidden = images.count <= 1
            scrollView.addSubview(pageControl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        pageControl = ISPageControl(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 20)), numberOfPages: images.count)
        setButton()
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignout), name: NSNotification.Name("Signout"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowForm"{
            let navController = segue.destination as! UINavigationController
            let controller = navController.viewControllers[0] as! EventApplyFormViewController
            controller.eventID = event.id!
        }
    }
    
    @objc func userDidSignout(){
        event.isLiked = "0"
        likeButton.setSelected(selected: false, animated: false)
    }
    
    var date: Date!
    
    func setData(){
        title = event.title!
        images = event.images!
        if images == nil || images.count == 0{
            noImages = true
        }
        else{
            heightConstraint.constant = height
        }
        heightConstraint.constant = height
        if event.location != nil{
            locationLabel.text = event.location!
        }
        titleLabel.text = event.title!
        descriptionLabel.text = event.description!
        if type == PostType.pastEvent{
            firstTitleLabel.text = "Likes".localized
            secondTitleLabel.text = "Views".localized
            thirdTitleLabel.text = "Media".localized
            fourthTitleLabel.isHidden = true
            fourthLabel.isHidden = true
            thirdLabel.text = "\(event.images!.count)"
            secondLabel.text = "\(event.totalViews!)"
            firstLabel.text = "\(event.totalLikes!)"
        }
        else{
            firstTitleLabel.text = "Days".localized
            secondTitleLabel.text = "Hours".localized
            thirdTitleLabel.text = "Minutes".localized
            fourthTitleLabel.text = "Seconds".localized
            fourthTitleLabel.isHidden = false
            fourthLabel.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.date(from: event.startDate! + " " + event.startTime!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let timer = Timer(timeInterval: 1, target: self, selector: #selector(shouldUpdateTime), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .common)
            shouldUpdateTime()
        }
    }
    
    var likeButton: FaveButton!{
        didSet{
            likeButton.delegate = self
            likeButton.selectedColor = .mainOrange
            titleContainerView.addSubview(likeButton)
            likeButton.isUserInteractionEnabled = false
            likeButton.setSelected(selected: event.isLiked! == "1", animated: false)
            eventButton.isHidden = true
            likeView = UIView()
        }
    }
    var likeView: UIView!{
        didSet{
            likeView.isUserInteractionEnabled = true
            likeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressLike)))
            titleContainerView.addSubview(likeView)
        }
    }
    
    func setButton(){
        if event.type! == "passed"{
            likeButton = FaveButton(frame: eventButton.frame, faveIconNormal: UIImage(named: "heart"))
        }
        else{
            
        }
    }
    
    @objc func didPressLike(){
        if !UserCache.isLoggedIn{
            let navController = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let controller = navController.viewControllers[0] as! SigninViewController
            controller.isModal = true
            present(navController, animated: true, completion: nil)
        }
        else{
            if event.isLiked! == "1"{
                Networking.events.dislikeEvent(["event_id":event.id!,"user_id":UserCache.userID]) { (model) in
                    if model != nil{
                        if model!.code! == "1"{
                            self.likeButton.setSelected(selected: false, animated: true)
                            self.firstLabel.text = "\(model!.data!.likesCount!)"
                            self.event.isLiked! = "0"
                            self.event.totalLikes = model!.data!.likesCount!
                            NotificationCenter.default.post(name: NSNotification.Name("EventLikeChanged"), object: nil, userInfo: ["id":self.event.id!,"count":model!.data!.likesCount!, "liked":false])
                        }
                        else{
                            Toast(text: model!.message!).show()
                        }
                    }
                    else{
                        Toast(text: "ERROR CONNECT MESSAGE".localized).show()
                    }
                }
            }
            else{
                Networking.events.likeEvent(["event_id":event.id!,"user_id":UserCache.userID]) { (model) in
                    if model != nil{
                        if model!.code! == "1"{
                            self.likeButton.setSelected(selected: true, animated: true)
                            self.firstLabel.text = "\(model!.data!.likesCount!)"
                            self.event.isLiked! = "1"
                            self.event.totalLikes = model!.data!.likesCount!
                            NotificationCenter.default.post(name: NSNotification.Name("EventLikeChanged"), object: nil, userInfo: ["id":self.event.id!,"count":model!.data!.likesCount!, "liked":true])
                        }
                        else{
                            Toast(text: model!.message!).show()
                        }
                    }
                    else{
                        Toast(text: "ERROR CONNECT MESSAGE".localized).show()
                    }
                }
            }
        }
    }
    
    @objc func shouldUpdateTime(){
        let now = Date()
        let dif = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
        firstLabel.text = "\(dif.day!)"
        secondLabel.text = "\(dif.hour!)"
        thirdLabel.text = "\(dif.minute!)"
        fourthLabel.text = "\(dif.second!)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if likeButton != nil{
            likeButton.frame = eventButton.frame
            likeView.frame = eventButton.frame
        }
        if pageControl != nil{
            pageControl.frame.origin = CGPoint(x: view.frame.midX - pageControl.frame.size.width / 2, y: collectionView.frame.origin.y + height - pageControl.frame.size.height)
        }
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
            pageControl.currentPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        }
    }
    
}
