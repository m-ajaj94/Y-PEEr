//
//  EditProfileModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

class EditProfileModel: Codable {
    let message, code: String?
    let data: [SigninModel]?
    
    init(message: String?, code: String?, data: [SigninModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}
