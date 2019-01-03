//
//  AboutCoreTeamTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/23/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class AboutCoreTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.backgroundColor = .clear
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            collectionView.allowsSelection = false
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            collectionView.collectionViewLayout = layout
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: String(describing: AboutCoreTeamCellCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: AboutCoreTeamCellCollectionViewCell.self))
        }
    }
    @IBOutlet weak var cellLabel: UILabel!{
        didSet{
            cellLabel.text = "Core Team".localized
        }
    }
    @IBOutlet weak var cellImage: UIImageView!
    
    var members: [CoreMemberModel]!{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension AboutCoreTeamTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(Int((collectionView.frame.size.width - 8) / (collectionView.frame.size.height + 8)), members.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AboutCoreTeamCellCollectionViewCell.self), for: indexPath) as? AboutCoreTeamCellCollectionViewCell{
            cell.cellImageView.kf.setImage(with: Networking.getImageURL(members[indexPath.row].imageURL!))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
}
