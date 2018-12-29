//
//  CoreTeamViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/23/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Presentr

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
    var numberOfColoumns: CGFloat = 2
    var members: [CoreMemberModel]!
    var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "coreTeamCover.jpg")!
            view.insertSubview(imageView, belowSubview: collectionView)
        }
    }
    let presenter: Presentr = {
        let width = ModalSize.custom(size: Float(UIScreen.main.bounds.width * 0.8))
        let height = ModalSize.custom(size: Float(UIScreen.main.bounds.height * 0.6))
        let center = ModalCenterPosition.center//custom(centerPoint: CGPoint(x: view.center.x, y: view.center.y - 44))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 10
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.4
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Team".localized
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
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CoreTeamCollectionViewCell.self), for: indexPath) as? CoreTeamCollectionViewCell{
            cell.member = members[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = UIStoryboard(name: "AboutUs", bundle: nil).instantiateViewController(withIdentifier: String(describing: CoreTeamPopupViewController.self)) as! CoreTeamPopupViewController
        controller.member = members[indexPath.row]
        customPresentViewController(presenter, viewController: controller, animated: true)
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
