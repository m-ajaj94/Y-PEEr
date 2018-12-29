//
//  AboutModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class AboutModel: Codable {
    public let message, code: String?
    public let data: AboutDataModel?
    
    public init(message: String?, code: String?, data: AboutDataModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class AboutDataModel: Codable {
    public let text, partnership: String?
    public let members: [CoreMemberModel]?
    
    public init(text: String?, partnership: String?, members: [CoreMemberModel]?) {
        self.text = text
        self.partnership = partnership
        self.members = members
    }
}

public class CoreMemberModel: Codable {
    public let id: Int?
    public let name, description, imageURL, membershipDate: String?
    public let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "image_url"
        case membershipDate = "membership_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public init(id: Int?, name: String?, description: String?, imageURL: String?, membershipDate: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.membershipDate = membershipDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
