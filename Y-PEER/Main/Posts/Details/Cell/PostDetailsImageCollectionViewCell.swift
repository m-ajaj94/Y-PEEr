//
//  PostDetailsImageCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/14/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class PostDetailsImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.backgroundColor = .clear
        }
    }
    var imageModel: ImageModel!{
        didSet{
            videoIcon.isHidden = imageModel.type! != "video"
            if imageModel.type! == "video"{
                VideoThumbnailCache.getThumbnailImage(forUrl: Networking.getImageURL(imageModel.imagePath!)) { (image, url) in
                    if url.absoluteString == Networking.getImageURL(self.imageModel.imagePath!).absoluteString{
                        self.cellImage.image = image
                        self.blurredImageView.image = image
                    }
                }
            }
            else{
                cellImage.kf.setImage(with: Networking.getImageURL(imageModel.thumbnailPath!))
                blurredImageView.kf.setImage(with: Networking.getImageURL(imageModel.thumbnailPath!))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
