//
//  Cache.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

struct Cache{
    
    struct stories {
        
        static let firstTimeKey = "FirstTimeStories"
        
        static var isFirstTime: Bool{
            if let value = UserDefaults.standard.value(forKey: firstTimeKey) as? Bool{
                return value
            }
            UserDefaults.standard.set(true, forKey: firstTimeKey)
            return false
        }
    }
    
    struct language {
        
        private static let currentLanguageKey = "CurrentLanguage"
        
        static var current: Language{
            let value = UserDefaults.standard.integer(forKey: currentLanguageKey)
            return Language(rawValue: value)!
            
        }
        
        static func setLanguage(language: Language){
            UserDefaults.standard.set(language.rawValue, forKey: currentLanguageKey)
            UserDefaults.standard.synchronize()
        }
        
        static func changeLanguage(language: Language){
            if language == .english{
                UserDefaults.standard.set(["En"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
            }
            else{
                UserDefaults.standard.set(["Ar"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
            }
        }
        
        static func setInitial(){
            let array = UserDefaults.standard.array(forKey: "AppleLanguages") as! [String]
            if array[0].contains("E") || array[0].contains("e"){
                setLanguage(language: .english)
                return
            }
            setLanguage(language: .arabic)
        }
        
        static var currentForNotifications: Language{
            let array = UserDefaults.standard.array(forKey: "AppleLanguages") as! [String]
            if array[0].contains("E") || array[0].contains("e"){
                return .english
            }
            return .arabic
        }
        
        enum Language: Int{
            case arabic = 1
            case english = 0
        }
        
    }
    struct cities{
        private static var citiesKey = "CitiesKey"
        static var cities: [CityModel]{
            get{
                if let dataArray = UserDefaults.standard.array(forKey: citiesKey) as? [Data]{
                    var array: [CityModel] = []
                    let decoder = JSONDecoder()
                    for data in dataArray{
                        array.append(try! decoder.decode(CityModel.self, from: data))
                    }
                    return array
                }
                return []
            }
            set{
                var dataArray: [Data] = []
                let encoder = JSONEncoder()
                for city in newValue{
                    dataArray.append(try! encoder.encode(city))
                }
                UserDefaults.standard.set(dataArray, forKey: citiesKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    struct settings{
        private static let postsKey = "NotificationsPost"
        private static let eventsKey = "NotificationsEvent"
        private static let quizKey = "NotificationsQuiz"
        static var current: [Int]{
            var array: [Int] = []
            if let value = UserDefaults.standard.value(forKey: postsKey) as? Int{
                array.append(value)
            }
            else{
                array.append(1)
                setPosts(1)
            }
            if let value = UserDefaults.standard.value(forKey: eventsKey) as? Int{
                array.append(value)
            }
            else{
                array.append(1)
                setEvents(1)
            }
            if let value = UserDefaults.standard.value(forKey: quizKey) as? Int{
                array.append(value)
            }
            else{
                array.append(1)
                setQuiz(1)
            }
            return array
        }
        static func setPosts(_ status: Int){
            UserDefaults.standard.set(status, forKey: postsKey)
            UserDefaults.standard.synchronize()
        }
        static func setEvents(_ status: Int){
            UserDefaults.standard.set(status, forKey: eventsKey)
            UserDefaults.standard.synchronize()
        }
        static func setQuiz(_ status: Int){
            UserDefaults.standard.set(status, forKey: quizKey)
            UserDefaults.standard.synchronize()
        }
    }
}
