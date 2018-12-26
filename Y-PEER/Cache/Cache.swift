//
//  Cache.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

struct Cache{
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
            }
            else{
                UserDefaults.standard.set(["Ar"], forKey: "AppleLanguages")
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
}
