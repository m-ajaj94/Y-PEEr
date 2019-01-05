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
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        return true
    }

}

