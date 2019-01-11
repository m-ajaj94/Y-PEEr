//
//  EventDetailsModel.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/11/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import Foundation

class EventDetailsModel: Codable {
    let message, code: String?
    let data: EventDataModel?
    
    init(message: String?, code: String?, data: EventDataModel?) {
        self.message = message
        self.code = code
        self.data = data
    }
}
