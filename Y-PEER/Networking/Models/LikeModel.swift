//
//  LikeModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class LikeGeneralModel: Codable {
    public let message, code: String?
    public let data: LikeModel?
    
    public init(message: String?, code: String?, data: LikeModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class LikeModel: Codable {
    public let likesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case likesCount = "likes_count"
    }
    
    public init(likesCount: Int?) {
        self.likesCount = likesCount
    }
}
