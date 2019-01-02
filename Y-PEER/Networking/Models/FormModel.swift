//
//  FormModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/1/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import Foundation

public class FormGeneralModel: Codable {
    public let message, code: String?
    public let data: FormModel?
    
    public init(message: String?, code: String?, data: FormModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}

public class FormModel: Codable {
    public let id, eventID: Int?
    public let createdAt, updatedAt: String?
    public let questions: [FormQuestionModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case questions
    }
    
    public init(id: Int?, eventID: Int?, createdAt: String?, updatedAt: String?, questions: [FormQuestionModel]?) {
        self.id = id
        self.eventID = eventID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.questions = questions
    }
}

public class FormQuestionModel: Codable {
    public let id: Int?
    public let text, type: String?
    public let formID: Int?
    public let createdAt, updatedAt: String?
    public let options: [FormOptionModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case type
        case formID = "form_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case options
    }
    
    public init(id: Int?, text: String?, type: String?, formID: Int?, createdAt: String?, updatedAt: String?, options: [FormOptionModel]?) {
        self.id = id
        self.text = text
        self.type = type
        self.formID = formID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.options = options
    }
}

public class FormOptionModel: Codable {
    public let id, questionID: Int?
    public let text, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case questionID = "question_id"
        case text
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    public init(id: Int?, questionID: Int?, text: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.questionID = questionID
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
