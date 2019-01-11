//
//  PostDetailsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/11/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import Foundation

class PostDetailsModel: Codable {
    let message, code: String?
    let data: PostModel?
    
    init(message: String?, code: String?, data: PostModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}
