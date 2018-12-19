//
//  IssuesModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/19/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class IssuesModel: Codable {
    public let message, code: String?
    public let data: [IssueModel]?
    
    public init(message: String?, code: String?, data: [IssueModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class IssueModel: Codable {
    public let id: Int?
    public let title, description, createdAt, updatedAt: String?
    public let images: [ImageModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case images
    }
    
    public init(id: Int?, title: String?, description: String?, createdAt: String?, updatedAt: String?, images: [ImageModel]?) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.images = images
    }
}
