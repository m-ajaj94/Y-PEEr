//
//  CoreTeamViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/23/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class CoreTeamViewController: ParentViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            layout.scrollDirection = .vertical
            collectionView.collectionViewLayout = layout
            collectionView.backgroundColor = .clear
            collectionView.alwaysBounceVertical = true
            collectionView.contentInset = UIEdgeInsets(top: height, left: spacing, bottom: 0, right: spacing)
            collectionView.register(UINib(nibName: String(describing: CoreTeamCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CoreTeamCollectionReusableView.self))
            collectionView.register(UINib(nibName: String(describing: CoreTeamCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CoreTeamCollectionViewCell.self))
        }
    }
    
    var height: CGFloat = 150
    var headerHeight: CGFloat = 150
    var spacing: CGFloat = 16
    var numberOfColoumns: CGFloat = 3
    
    var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            view.insertSubview(imageView, belowSubview: collectionView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        view.backgroundColor = .mainGray
        imageView = UIImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if imageView != nil && collectionView != nil{
            imageView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: max(0, -collectionView.contentOffset.y + headerHeight / 2)))
        }
        collectionView.layoutSubviews()
    }

}

extension CoreTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CoreTeamCollectionViewCell.self), for: indexPath) as? CoreTeamCollectionViewCell{
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CoreTeamCollectionReusableView.self), for: indexPath) as? CoreTeamCollectionReusableView{
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (numberOfColoumns + 1) * spacing) / numberOfColoumns
        return CGSize(width: width, height: width + 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imageView != nil && collectionView != nil{
            imageView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: max(0, -collectionView.contentOffset.y + headerHeight / 2)))
        }
    }
    
}
