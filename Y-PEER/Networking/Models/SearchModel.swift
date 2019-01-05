//
//  SearchModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/5/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import Foundation

public class SearchGeneralModel: Codable {
    public let data: SearchModel?
    public let message, code: String?
    
    public init(data: SearchModel?, message: String?, code: String?) {
        self.data = data
        self.message = message
        self.code = code
    }
}

public class SearchModel: Codable {
    public var posts: [PostModel]?
    public var events: [EventDataModel]?
    public var stories: [StoryModel]?
    public var articles: [ArticleModel]?
    
    public init(posts: [PostModel]?, events: [EventDataModel]?, stories: [StoryModel]?, articles: [ArticleModel]?) {
        self.posts = posts
        self.events = events
        self.stories = stories
        self.articles = articles
    }
}
