//
//  SearchPagingPostsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/5/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import Foundation

public class SearchPagingPostsModel: Codable {
    public let message: String?
    public let data: [PostModel]?
    public let code: String?
    
    public init(message: String?, data: [PostModel]?, code: String?) {
        self.message = message
        self.data = data
        self.code = code
    }
}

public class SearchPagingEventsModel: Codable {
    public let message: String?
    public let data: [EventDataModel]?
    public let code: String?
    
    public init(message: String?, data: [EventDataModel]?, code: String?) {
        self.message = message
        self.data = data
        self.code = code
    }
}

public class SearchPagingArticlesModel: Codable {
    public let message: String?
    public let data: [ArticleModel]?
    public let code: String?
    
    public init(message: String?, data: [ArticleModel]?, code: String?) {
        self.message = message
        self.data = data
        self.code = code
    }
}

public class SearchPagingStoriesModel: Codable {
    public let message: String?
    public let data: [StoryModel]?
    public let code: String?
    
    public init(message: String?, data: [StoryModel]?, code: String?) {
        self.message = message
        self.data = data
        self.code = code
    }
}
