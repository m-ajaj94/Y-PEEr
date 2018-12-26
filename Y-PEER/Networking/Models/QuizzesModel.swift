//
//  QuizzesModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

class QuizzesModel: Codable {
    let message, code: String?
    let data: [QuizModel]?
    
    init(message: String?, code: String?, data: [QuizModel]?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class QuizModel: Codable {
    let id: Int?
    let title: String?
    let referencesLinks: String?
    let questionsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case referencesLinks = "references_links"
        case questionsCount = "questions_count"
    }
    
    init(id: Int?, title: String?, referencesLinks: String?, questionsCount: Int?) {
        self.id = id
        self.title = title
        self.referencesLinks = referencesLinks
        self.questionsCount = questionsCount
    }
}
