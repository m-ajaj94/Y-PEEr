//
//  GalleryCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoIcon: UIImageView!{
        didSet{
            videoIcon.isHidden = true
        }
    }
    @IBOutlet weak var cellImage: UIImageView!{
        didSet{
            cellImage.contentMode = .scaleAspectFill
        }
    }
    
    var imageModel: ImageModel!{
        didSet{
            videoIcon.isHidden = imageModel.type! != "video"
            if imageModel.type! == "video"{
                VideoThumbnailCache.getThumbnailImage(forUrl: Networking.getImageURL(imageModel.imagePath!)) { (image, url) in
                    if url.absoluteString == Networking.getImageURL(self.imageModel.imagePath!).absoluteString{
                        self.cellImage.image = image
                    }
                }
            }
            else{
                cellImage.kf.setImage(with: Networking.getImageURL(imageModel.thumbnailPath!))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.image = nil
        cellImage.backgroundColor = .white
    }

}
