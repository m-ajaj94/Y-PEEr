//
//  CitiesModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class CitiesModel: Codable {
    public let message, code: String?
    public let data: [CityModel]?
    
    public init(message: String?, code: String?, data: [CityModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class CityModel: Codable {
    public let id: Int?
    public let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
