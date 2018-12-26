//
//  EventsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

class EventsModel: Codable {
    let message, code: String?
    let data: EventsDataModel?
    
    init(message: String?, code: String?, data: EventsDataModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
    
}

struct EventsDataModel: Codable {
    let upcoming: [EventDetailsModel]?
    let passed: [EventDetailsModel]?
    let now: [EventDetailsModel]?
    
    init(upcoming: [EventDetailsModel]?, passed: [EventDetailsModel]?, now: [EventDetailsModel]?) {
        self.upcoming = upcoming
        self.passed = passed
        self.now = now
    }
}

struct EventDetailsModel: Codable {
    let id: Int?
    let title, description, createdAt, updatedAt: String?
    let location, startTime, startDate, endDate: String?
    let isLiked, isViewed: String?
    let totalViews, totalLikes: Int?
    let images: [ImageModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case location
        case startTime = "start_time"
        case startDate = "start_date"
        case endDate = "end_date"
        case isLiked = "is_liked"
        case isViewed = "is_viewed"
        case totalViews = "total_views"
        case totalLikes = "total_likes"
        case images
    }
    
    init(id: Int?, title: String?, description: String?, createdAt: String?, updatedAt: String?, location: String?, startTime: String?, startDate: String?, endDate: String?, isLiked: String?, isViewed: String?, totalViews: Int?, totalLikes: Int?, images: [ImageModel]?) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.location = location
        self.startTime = startTime
        self.startDate = startDate
        self.endDate = endDate
        self.isLiked = isLiked
        self.isViewed = isViewed
        self.totalViews = totalViews
        self.totalLikes = totalLikes
        self.images = images
    }
}
