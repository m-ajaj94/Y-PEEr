//
//  RequestNames.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import Foundation

enum RequestNames: String{
    case signup = "signup"
    case signin = "signin"
    case updateProfile = "updateprofile"
    case forgotPassword = "frogetpassword"
    
    case getPosts = "getposts"
    case dislikePost = "unlike_post"
    case likePost = "like_post"
    
    case getIssues = "getissues"
    case getArticles = "getarticles"
    
    case getCities = "getcities"
    
    case gallery = "getGallery"
    
    case getEvents = "getevents"
    
    case getQuizzes = "getquizzes"
    
    case getQuiz = "getquiz"
    
    case getStories = "getexperimentforuser"
    case createStory = "addexperiment"
    
    case getAbout = "getaboutus"
}
