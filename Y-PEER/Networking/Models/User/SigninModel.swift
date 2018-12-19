//
//  SigninModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/19/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class SigninGeneralModel: Codable {
    public let message, code: String?
    public let data: SigninModel?
    
    public init(message: String?, code: String?, data: SigninModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class SigninModel: Codable {
    public let id: Int?
    public let name, birthdate: String?
    public let gender: Int?
    public let email: String?
    public let cityID: Int?
    public let type, password, createdAt, updatedAt: String?
    public let deletedAt, tokenKey: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthdate, gender, email
        case cityID = "city_id"
        case type, password
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case tokenKey = "token_key"
    }
    
    public init(id: Int?, name: String?, birthdate: String?, gender: Int?, email: String?, cityID: Int?, type: String?, password: String?, createdAt: String?, updatedAt: String?, deletedAt: String?, tokenKey: String?) {
        self.id = id
        self.name = name
        self.birthdate = birthdate
        self.gender = gender
        self.email = email
        self.cityID = cityID
        self.type = type
        self.password = password
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.tokenKey = tokenKey
    }
}
