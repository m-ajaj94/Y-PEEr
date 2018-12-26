//
//  GalleryModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class GalleryModel: Codable {
    public let message, code: String?
    public let data: GalleryDataModel?
    
    public init(message: String?, code: String?, data: GalleryDataModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class GalleryDataModel: Codable {
    public let images: [ImageModel]?
    public let videos: [ImageModel]?
    
    public init(images: [ImageModel]?, videos: [ImageModel]?) {
        self.images = images
        self.videos = videos
    }
}
