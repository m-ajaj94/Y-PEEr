//
//  GalleryViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SkeletonView

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
                collectionView.collectionViewLayout = layout
                collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
            self.collectionView.isHidden = true
            self.videoCollectionView.isHidden = false
        }
    }
    
    private let numberOfColoumns: CGFloat = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SkeletonAppearance.default.tintColor = .shadeOrange
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: .shadeOrange, secondaryColor: .white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.prepareSkeleton { (success) in
            self.view.showAnimatedGradientSkeleton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.hideSkeleton(reloadDataAfter: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allButton.layer.cornerRadius = allButton.frame.size.height / 2
        photosButton.layer.cornerRadius = photosButton.frame.size.height / 2
        videosButton.layer.cornerRadius = videosButton.frame.size.height / 2
    }

}

extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: GallerySkeletonCollectionViewCell.self)
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
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 16  - ((numberOfColoumns - 1) * 8)) / numberOfColoumns
        return CGSize(width: width, height: width)
    }
    
}
