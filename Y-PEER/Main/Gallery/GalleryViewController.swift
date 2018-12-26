//
//  GalleryViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SkeletonView
import FMMosaicLayout
import Toaster

class GalleryViewController: ParentViewController {

    @IBOutlet weak var videoCollectionView: UICollectionView!{
        didSet{
            if videoCollectionView != nil{
                videoCollectionView.isHidden = true
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            if collectionView != nil{
                collectionView.delegate = self
                collectionView.dataSource = self
                let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 8
                layout.minimumLineSpacing = 8
                layout.scrollDirection = .vertical
                let mosaiicLayout = FMMosaicLayout()
                mosaiicLayout.delegate = self
                collectionView.collectionViewLayout = mosaiicLayout
                refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                collectionView.refreshControl = refreshControl
                collectionView.register(UINib(nibName: String(describing: GalleryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GalleryCollectionViewCell.self))
                collectionView.register(UINib(nibName: String(describing: GallerySkeletonCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GallerySkeletonCollectionViewCell.self))
            }
        }
    }
    @IBOutlet weak var videosButton: UIButton!{
        didSet{
            if videosButton != nil{
                videosButton.layer.borderColor = UIColor.mainOrange.cgColor
                videosButton.layer.borderWidth = 1
            }
        }
    }
    @IBOutlet weak var photosButton: UIButton!{
        didSet{
            if photosButton != nil{
                photosButton.layer.borderColor = UIColor.mainOrange.cgColor
                photosButton.layer.borderWidth = 1
            }
        }
    }
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            if allButton != nil{
                allButton.layer.borderColor = UIColor.mainOrange.cgColor
                allButton.layer.borderWidth = 1
            }
        }
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if let tabController = tabBarController as? MainTabBarController{
            tabController.showSideMenu()
        }
    }
    @IBAction func allButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.allButton.backgroundColor = .mainOrange
            self.photosButton.backgroundColor = .white
            self.videosButton.backgroundColor = .white
            self.allButton.setTitleColor(.white, for: .normal)
            self.photosButton.setTitleColor(.mainOrange, for: .normal)
            self.videosButton.setTitleColor(.mainOrange, for: .normal)
            self.collectionView.isHidden = false
            self.videoCollectionView.isHidden = true
        }
    }
    @IBAction func photosButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.photosButton.backgroundColor = .mainOrange
            self.allButton.backgroundColor = .white
            self.videosButton.backgroundColor = .white
            self.photosButton.setTitleColor(.white, for: .normal)
            self.allButton.setTitleColor(.mainOrange, for: .normal)
            self.videosButton.setTitleColor(.mainOrange, for: .normal)
            self.collectionView.isHidden = false
            self.videoCollectionView.isHidden = true
        }
        collectionView.hideSkeleton(reloadDataAfter: true)
    }
    @IBAction func videosButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.videosButton.backgroundColor = .mainOrange
            self.photosButton.backgroundColor = .white
            self.allButton.backgroundColor = .white
            self.videosButton.setTitleColor(.white, for: .normal)
            self.photosButton.setTitleColor(.mainOrange, for: .normal)
            self.allButton.setTitleColor(.mainOrange, for: .normal)
            self.collectionView.isHidden = false
            self.videoCollectionView.isHidden = true
        }
    }
    
    private let numberOfColoumns: CGFloat = 2
    var media: [ImageModel]!{
        didSet{
            collectionView.reloadData()
        }
    }
    let pageSize: Int = 18
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        requestData()
        collectionView.addInfiniteScroll { (collectionView) in
            self.moreRequest()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func requestData(){
        showLoading()
        Networking.gallery(["skip":0, "take":pageSize]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.media = model!.data!.images!
                }
                else{
                    
                }
            }
            else{
                self.showNoConnection()
            }
        }
    }
    
    @objc func refreshData(){
        Networking.gallery(["skip":0, "take":pageSize]) { (model) in
            self.refreshControl.endRefreshing()
            if model != nil{
                if model!.code == "1"{
                    self.media = model!.data!.images!
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "Error Message TODO".localized).show()
            }
        }
    }
    
    func moreRequest(){
        Networking.gallery(["skip":media.count, "take":pageSize]) { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.media.append(contentsOf: model!.data!.images!)
                    self.collectionView.finishInfiniteScroll()
                    self.collectionView.reloadData()
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "Error Message TODO".localized).show()
            }
        }
    }
    
    @objc override func didPressRetry() {
        self.removeNoConnection()
        self.requestData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        view.hideSkeleton(reloadDataAfter: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allButton.layer.cornerRadius = allButton.frame.size.height / 2
        photosButton.layer.cornerRadius = photosButton.frame.size.height / 2
        videosButton.layer.cornerRadius = videosButton.frame.size.height / 2
    }

}

extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource, FMMosaicLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, numberOfColumnsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, mosaicCellSizeForItemAt indexPath: IndexPath!) -> FMMosaicCellSize {
        if indexPath.row % 3 == 1{
            return .big
        }
        return .small
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if media == nil{
            return 0
        }
        return media.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: GallerySkeletonCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isSkeletonActive{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GallerySkeletonCollectionViewCell.self), for: indexPath) as? GallerySkeletonCollectionViewCell{
                return cell
            }
        }
        else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryCollectionViewCell.self), for: indexPath) as? GalleryCollectionViewCell{
                cell.cellImage.kf.setImage(with: Networking.getImageURL(media[indexPath.row].thumbnailPath!))
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImages(media, indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 16  - ((numberOfColoumns - 1) * 8)) / numberOfColoumns
        return CGSize(width: width, height: width)
    }
    
}
