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
    public let data: [ImageModel]?
    
    public init(message: String?, code: String?, data: [ImageModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}
