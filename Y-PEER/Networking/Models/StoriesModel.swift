//
//  StoriesModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/28/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class StoriesModel: Codable {
    public let message, code: String?
    public let data: [StoryModel]?
    
    public init(message: String?, code: String?, data: [StoryModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class StoryModel: Codable {
    public let id: Int?
    public let story: String?
    public let userID, issueID, nameVisibility, posted: Int?
    public let createdAt, updatedAt, isViewed: String?
    public let totalViews: Int?
    public let issueName: IssueNameModel?
    public let username: UsernameModel?
    
    enum CodingKeys: String, CodingKey {
        case id, story
        case userID = "user_id"
        case issueID = "issue_id"
        case nameVisibility = "name_visibility"
        case posted
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isViewed = "is_viewed"
        case totalViews = "total_views"
        case issueName = "issue_name"
        case username
    }
    
    public init(id: Int?, story: String?, userID: Int?, issueID: Int?, nameVisibility: Int?, posted: Int?, createdAt: String?, updatedAt: String?, isViewed: String?, totalViews: Int?, issueName: IssueNameModel?, username: UsernameModel?) {
        self.id = id
        self.story = story
        self.userID = userID
        self.issueID = issueID
        self.nameVisibility = nameVisibility
        self.posted = posted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isViewed = isViewed
        self.totalViews = totalViews
        self.issueName = issueName
        self.username = username
    }
}

public class IssueNameModel: Codable {
    public let title: String?
    
    public init(title: String?) {
        self.title = title
    }
}

public class UsernameModel: Codable {
    public let name: String?
    
    public init(name: String?) {
        self.name = name
    }
}
