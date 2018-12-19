//
//  UserCache.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

struct UserCache{
    
    private static let isLoggedInKey = "IsLoggedIn"
    private static let userDataKey = "UserData"
    
    static var isLoggedIn: Bool{
        if let status = UserDefaults.standard.value(forKey: isLoggedInKey) as? Bool{
            return status
        }
        return false
    }
    
    static var userData: SigninModel!{
        if let data = UserDefaults.standard.value(forKey: userDataKey) as? Data{
            return try! JSONDecoder().decode(SigninModel.self, from: data)
        }
        return nil
    }
    
    static func signin(_ model: SigninModel){
        let data = try! JSONEncoder().encode(model)
        UserDefaults.standard.set(data, forKey: userDataKey)
        setLoggedIn(true)
    }
    
    static func signout(){
        UserDefaults.standard.set(nil, forKey: userDataKey)
        UserCache.setLoggedIn(false)
    }
    
    private static func setLoggedIn(_ status: Bool){
        UserDefaults.standard.set(status, forKey: isLoggedInKey)
        UserDefaults.standard.synchronize()
    }
    
}
