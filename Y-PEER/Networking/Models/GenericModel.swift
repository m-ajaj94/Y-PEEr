//
//  GenericModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/18/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class GenericModel: Codable {
    public let message, code: String
    
    public init(message: String, code: String) {
        self.message = message
        self.code = code
    }
}
