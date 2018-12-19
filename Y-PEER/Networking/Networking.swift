//
//  Networking.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/18/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Networking{
    
    private static var serverURL: String{
        return "https://ypeer-syria.org/api/"
    }
    private static var serverImageURL: String{
        return "https://ypeer-syria.org/"
    }
    
    private static func getURL(_ request: RequestNames) -> URL{
        return URL(string: serverURL + request.rawValue)!
    }
    
    static func getImageURL(_ string: String) -> URL{
        return URL(string: serverImageURL + string)!
    }
    
    private static var headers: HTTPHeaders{
        var _headers: HTTPHeaders = [:]
        _headers["Content-Type"] = "application/json"
        _headers["language"] = "ar" //TODO: Handle Language
        return _headers
    }
    
    private static func post(_ request: RequestNames, _ params: [String:Any],_ completionHandler: @escaping (Data?)->()){
        let url = getURL(request)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result{
                case .success:
                    completionHandler(response.data!)
                case .failure:
                    completionHandler(nil)
                }
            }
        }
    }
    
    private static func get(_ request: RequestNames, _ params: [String:Any],_ completionHandler: @escaping (Data?)->()){
        let url = getURL(request)
        Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result{
                case .success:
                    completionHandler(response.data!)
                case .failure:
                    completionHandler(nil)
                }
            }
        }
    }
    
    struct user{
        static func signup(_ params: [String:Any], completionHandler: @escaping (GenericModel?)->()){
            Networking.post(.signup, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(GenericModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func signin(_ params: [String:Any], completionHandler: @escaping (SigninGeneralModel?)->()){
            Networking.post(.signin, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SigninGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func updateProfile(_ params: [String:Any], completionHandler: @escaping (SigninGeneralModel?)->()){
            Networking.post(.updateProfile, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SigninGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
    struct posts{
        static func homePosts(_ params: [String:Any], completionHandler: @escaping (PostsModel?)->()){
            Networking.post(.getPosts, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(PostsModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
    struct issues{
        static func getIssues(_ completionHandler: @escaping (IssuesModel?)->()){
            Networking.get(.getIssues, [:]) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(IssuesModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
}
