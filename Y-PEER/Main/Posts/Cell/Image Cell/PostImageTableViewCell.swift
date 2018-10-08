//
//  PostImageTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/8/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

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
        likeButton.setTitle("😍", for: .normal)
        delegate.didPressLike(at: index)
    }
    
    var delegate: PostImageTableViewCellDelegate!
    var index: IndexPath!
    var images: [String]!{
        didSet{
            switch images.count {
            case 1:
                collectionViewHeightConstraint.constant = frame.size.width * 3 / 5
                collectionView.contentInset = .zero
                break
            case 2:
                collectionViewHeightConstraint.constant = frame.size.width * 1 / 2
                collectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
                break
            default:
                collectionViewHeightConstraint.constant = frame.size.width
                collectionView.contentInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            }
            layoutIfNeeded()
        }
    }
    private let spacing: CGFloat = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
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
            cell.cellImage.image = UIImage(named: images[indexPath.row])
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
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        case 2:
            let width = (collectionView.frame.size.width - (3 * spacing)) / 2
            return CGSize(width: width, height: width)
        case 3:
            let width = (collectionView.frame.size.width - (3 * spacing)) / 2
            let height = (collectionView.frame.size.height - spacing * 3) / 2
            switch indexPath.row{
            case 0:
                return CGSize(width: collectionView.frame.size.width, height: height)
            case 1:
                return CGSize(width: width, height: height)
            case 2:
                return CGSize(width: width, height: height)
            default:
                return .zero
            }
        default:
            let width = (collectionView.frame.size.width - (3 * spacing)) / 2
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
