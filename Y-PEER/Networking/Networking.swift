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
        return "https://www.ypeer-syria.org/api/"
    }
    private static var serverImageURL: String{
        return "https://www.ypeer-syria.org/"
    }
    
    private static func getURL(_ request: RequestNames) -> URL{
        return URL(string: serverURL + request.rawValue)!
    }
    
    static func getImageURL(_ string: String) -> URL{
        if let url = URL(string: serverImageURL + string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!){
            return url
        }
        return URL(string: serverImageURL)!
    }
    
    private static var headers: HTTPHeaders{
        var _headers: HTTPHeaders = [:]
        _headers["Content-Type"] = "application/json"
        _headers["os"] = "mobile"
        if Cache.language.current == .arabic{
            _headers["language"] = "ar"
        }
        else{
            _headers["language"] = "en"
        }
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
    
    private static func get(_ request: RequestNames, _ params: [String:Any]?,_ completionHandler: @escaping (Data?)->()){
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
    
    static func getAboutUs(_ completionHandler: @escaping (AboutModel?)->()){
        Networking.get(.getAbout, nil) { (data) in
            if data == nil{
                completionHandler(nil)
            }
            else{
                let model = try? JSONDecoder().decode(AboutModel.self, from: data!)
                completionHandler(model)
            }
        }
    }
    static func getCities(_ completionHandler: @escaping (CitiesModel?)->()){
        Networking.get(.getCities, nil) { (data) in
            if data == nil{
                completionHandler(nil)
            }
            else{
                let model = try? JSONDecoder().decode(CitiesModel.self, from: data!)
                completionHandler(model)
            }
        }
    }
    
    static func gallery(_ params: [String:Any], _ completionHandler: @escaping (GalleryModel?)->()){
        Networking.post(.gallery, params) { (data) in
            if data == nil{
                completionHandler(nil)
            }
            else{
                let model = try? JSONDecoder().decode(GalleryModel.self, from: data!)
                completionHandler(model)
            }
        }
    }
    
    struct search{
        static func search(_ params: [String:Any], completionHandler: @escaping (SearchGeneralModel?)->()){
            Networking.post(.search, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SearchGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func pageArticles(_ params: [String:Any], completionHandler: @escaping (SearchPagingArticlesModel?)->()){
            Networking.post(.searchPaging, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SearchPagingArticlesModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func pagePosts(_ params: [String:Any], completionHandler: @escaping (SearchPagingPostsModel?)->()){
            Networking.post(.searchPaging, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SearchPagingPostsModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func pageEvents(_ params: [String:Any], completionHandler: @escaping (SearchPagingEventsModel?)->()){
            Networking.post(.searchPaging, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SearchPagingEventsModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func pageStories(_ params: [String:Any], completionHandler: @escaping (SearchPagingStoriesModel?)->()){
            Networking.post(.searchPaging, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(SearchPagingStoriesModel.self, from: data!)
                    completionHandler(model)
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
        static func updateProfile(_ params: [String:Any], completionHandler: @escaping (EditProfileModel?)->()){
            Networking.post(.updateProfile, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(EditProfileModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func forgotPassword(_ params: [String:Any], completionHandler: @escaping (SigninGeneralModel?)->()){
            Networking.post(.forgotPassword, params) { (data) in
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
        static func likePost(_ params: [String:Any], completionHandler: @escaping (LikeGeneralModel?)->()){
            Networking.post(.likePost, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(LikeGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func dislikePost(_ params: [String:Any], completionHandler: @escaping (LikeGeneralModel?)->()){
            Networking.post(.dislikePost, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(LikeGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
    struct issues{
        static func getIssues(_ completionHandler: @escaping (IssuesModel?)->()){
            Networking.get(.getIssues, nil) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(IssuesModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func getArticles(_ params: [String:Any], _ completionHandler: @escaping (ArticlesModel?)->()){
            Networking.post(.getArticles, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(ArticlesModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
    struct events {
        static func getEvents(_ params: [String:Any], _ completionHandler: @escaping (EventsModel?)->()){
            Networking.post(.getEvents, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(EventsModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func getForm(_ params: [String:Any], _ completionHandler: @escaping (FormGeneralModel?)->()){
            Networking.post(.formEvent, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(FormGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func likeEvent(_ params: [String:Any], _ completionHandler: @escaping (LikeGeneralModel?)->()){
            Networking.post(.likeEvent, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(LikeGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func dislikeEvent(_ params: [String:Any], _ completionHandler: @escaping (LikeGeneralModel?)->()){
            Networking.post(.dislikeEvent, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(LikeGeneralModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func submitForm(_ params: [String:Any], _ completionHandler: @escaping (GenericModel?)->()){
            Networking.post(.submitForm, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(GenericModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
    struct quiz{
        static func getQuizzes(_ params: [String:Any], _ completionHandler: @escaping (QuizzesModel?)->()){
            Networking.post(.getQuizzes, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(QuizzesModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func getQuiz(_ params: [String:Any], _ completionHandler: @escaping (QuizDetailsModel?)->()){
            Networking.post(.getQuiz, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(QuizDetailsModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
    struct stories{
        static func getStories(_ params: [String:Any], _ completionHandler: @escaping (StoriesModel?)->()){
            Networking.post(.getStories, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(StoriesModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
        static func createStory(_ params: [String:Any], _ completionHandler: @escaping (GenericModel?)->()){
            Networking.post(.createStory, params) { (data) in
                if data == nil{
                    completionHandler(nil)
                }
                else{
                    let model = try? JSONDecoder().decode(GenericModel.self, from: data!)
                    completionHandler(model)
                }
            }
        }
    }
    
}
