//
//  QuizDetailsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

class QuizDetailsModel: Codable {
    let message, code: String?
    let data: QuizDetails?
    
    init(message: String?, code: String?, data: QuizDetails?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

class QuizDetails: Codable {
    let id: Int?
    let title, referencesLinks: String?
    let questions: [QuizQuestionModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case referencesLinks = "references_links"
        case questions
    }
    
    init(id: Int?, title: String?, referencesLinks: String?, questions: [QuizQuestionModel]?) {
        self.id = id
        self.title = title
        self.referencesLinks = referencesLinks
        self.questions = questions
    }
}

class QuizQuestionModel: Codable {
    let id: Int?
    let description, hint: String?
    let options: [QuizQuestionOptionModelModel]?
    
    init(id: Int?, description: String?, hint: String?, options: [QuizQuestionOptionModelModel]?) {
        self.id = id
        self.description = description
        self.hint = hint
        self.options = options
    }
}

class QuizQuestionOptionModelModel: Codable {
    let id: Int?
    let description: String?
    let isTrue: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, description
        case isTrue = "is_true"
    }
    
    init(id: Int?, description: String?, isTrue: Int?) {
        self.id = id
        self.description = description
        self.isTrue = isTrue
    }
}
