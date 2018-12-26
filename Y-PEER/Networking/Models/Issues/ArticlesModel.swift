//
//  ArticlesModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/20/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

public class ArticlesModel: Codable {
    public let message, code: String?
    public let data: [ArticleModel]?
    
    public init(message: String?, code: String?, data: [ArticleModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class ArticleModel: Codable {
    public let id: Int?
    public let titleEn, titleAr, descriptionAr, descriptionEn: String?
    public let createdAt, updatedAt: String?
    public let images: [ImageModel]?
    public let isViewed: String?
    public let totalViews: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case images
        case isViewed = "is_viewed"
        case totalViews = "total_views"
    }
    
    public init(id: Int?, titleEn: String?, titleAr: String?, descriptionAr: String?, descriptionEn: String?, createdAt: String?, updatedAt: String?, images: [ImageModel]?, isViewed: String?, totalViews: Int?) {
        self.id = id
        self.titleEn = titleEn
        self.titleAr = titleAr
        self.descriptionAr = descriptionAr
        self.descriptionEn = descriptionEn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.images = images
        self.isViewed = isViewed
        self.totalViews = totalViews
    }
}
