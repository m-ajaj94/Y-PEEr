//
//  EventsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class EventsModel: Codable {
    public let message, code: String?
    public let data: [EventDataModel]?
    
    public init(message: String?, code: String?, data: [EventDataModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class EventDataModel: Codable {
    public let id: Int?
    public let title, description, createdAt, updatedAt: String?
    public let location, startTime, startDate, endDate: String?
    public let posted: Int?
    public var isLiked, isViewed: String?
    public var totalViews, totalLikes: Int?
    public let images: [ImageModel]?
    public let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case location
        case startTime = "start_time"
        case startDate = "start_date"
        case endDate = "end_date"
        case posted
        case isLiked = "is_liked"
        case isViewed = "is_viewed"
        case totalViews = "total_views"
        case totalLikes = "total_likes"
        case images, type
    }
    
    public init(id: Int?, title: String?, description: String?, createdAt: String?, updatedAt: String?, location: String?, startTime: String?, startDate: String?, endDate: String?, posted: Int?, isLiked: String?, isViewed: String?, totalViews: Int?, totalLikes: Int?, images: [ImageModel]?, type: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.location = location
        self.startTime = startTime
        self.startDate = startDate
        self.endDate = endDate
        self.posted = posted
        self.isLiked = isLiked
        self.isViewed = isViewed
        self.totalViews = totalViews
        self.totalLikes = totalLikes
        self.images = images
        self.type = type
    }
}
