//
//  UserCache.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

struct UserCache{
    
    static var isLoggedIn: Bool{
        if let status = UserDefaults.standard.value(forKey: "IsLoggedIn") as? Bool{
            return status
        }
        return false
    }
    
    static func setLoggedIn(_ status: Bool){
        UserDefaults.standard.set(status, forKey: "IsLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
}
