//
//  AppDelegate.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/13/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster
import Firebase
import FirebaseMessaging
import UserNotifications
import Lightbox
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Networking.getCities { (model) in
            if model != nil{
                Cache.cities.cities = model!.data!
            }
        }
        ToastView.appearance().backgroundColor = .mainOrange
        ToastView.appearance().textColor = .white
        ToastView.appearance().textInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        ToastView.appearance().cornerRadius = 4
        ToastView.appearance().bottomOffsetPortrait = 128
        Cache.language.setInitial()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        LightboxConfig.CloseButton.enabled = false
        Messaging.messaging().delegate = self
        if let token = Messaging.messaging().fcmToken{
            Networking.sendSettings(token) { (model) in
                //Something
            }
        }
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Networking.sendSettings(fcmToken) { (model) in
            //Something
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let data = userInfo["gcm.notification.data"]! as! String
        let json = JSON.init(parseJSON: data)
        let type = json["type"].stringValue
        let id = json["id"].stringValue
        if let topController = application.topMostViewController{
            if let navController = topController.navigationController{
                switch type {
                case "post":
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: PostDetailsViewController.self)) as! PostDetailsViewController
                    controller.postID = id
                    navController.pushViewController(controller, animated: true)
                    break
                case "event":
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventDetailsViewController.self)) as! EventDetailsViewController
                    controller.eventID = id
                    navController.pushViewController(controller, animated: true)
                    break
                case "quiz":
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: QuizViewController.self)) as! QuizViewController
                    controller.quizID = Int(id)
                    navController.pushViewController(controller, animated: true)
                    break
                default:
                    break
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .sound])
    }
    
}

