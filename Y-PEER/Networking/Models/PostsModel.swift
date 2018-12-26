//
//  PostsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/18/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let postsModel = try? newJSONDecoder().decode(PostsModel.self, from: jsonData)

import Foundation

public class PostsModel: Codable {
    public let message: String
    public let data: [PostModel]?
    public let code: String
    
    public init(message: String, data: [PostModel]?, code: String) {
        self.message = message
        self.data = data
        self.code = code
    }
}

public class PostModel: Codable {
    public let id, eventID, quizID: Int?
    public let title, description, createdAt, updatedAt: String?
    public var isLiked: String?
    public var totalLikes: Int?
    public let images: [ImageModel]?
    public let event: EventModel?
    public let quiz: QuizModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case quizID = "quiz_id"
        case title, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isLiked = "is_liked"
        case totalLikes = "total_likes"
        case images, event, quiz
    }
    
    public init(id: Int?, eventID: Int?, quizID: Int?, title: String?, description: String?, createdAt: String?, updatedAt: String?, isLiked: String?, totalLikes: Int?, images: [ImageModel]?, event: EventModel?, quiz: QuizModel?) {
        self.id = id
        self.eventID = eventID
        self.quizID = quizID
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isLiked = isLiked
        self.totalLikes = totalLikes
        self.images = images
        self.event = event
        self.quiz = quiz
    }
}


public class EventModel: Codable {
    public let id: Int?
    public let title, description: String?
    public let startDate, endDate, startTime, endTime: String?
    public let locationAr: String?
    public let visitors, posted: Int?
    public let locationEn, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case locationAr = "location_ar"
        case visitors, posted
        case locationEn = "location_en"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public init(id: Int?, title: String?, description: String?, startDate: String?, endDate: String?, startTime: String?, endTime: String?, locationAr: String?, visitors: Int?, posted: Int?, locationEn: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
        self.locationAr = locationAr
        self.visitors = visitors
        self.posted = posted
        self.locationEn = locationEn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public class ImageModel: Codable {
    public let id: Int?
    public let userID: String?
    public let memberID, postID, issueID, eventID: Int?
    public let articleID: Int?
    public let type, name, imagePath, thumbnailPath: String?
    public let createdAt, updatedAt: String?
    public let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case memberID = "member_id"
        case postID = "post_id"
        case issueID = "issue_id"
        case eventID = "event_id"
        case articleID = "article_id"
        case type, name
        case imagePath = "image_path"
        case thumbnailPath = "thumbnail_path"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
    
    public init(id: Int?, userID: String?, memberID: Int?, postID: Int?, issueID: Int?, eventID: Int?, articleID: Int?, type: String?, name: String?, imagePath: String?, thumbnailPath: String?, createdAt: String?, updatedAt: String?, deletedAt: String?) {
        self.id = id
        self.userID = userID
        self.memberID = memberID
        self.postID = postID
        self.issueID = issueID
        self.eventID = eventID
        self.articleID = articleID
        self.type = type
        self.name = name
        self.imagePath = imagePath
        self.thumbnailPath = thumbnailPath
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
