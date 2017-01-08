//
//  AppDelegate.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/22/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

/*
 static var dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
 static var enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
 static var dateFormatter: DateFormatter!
*/

import UIKit
import Firebase
import BEMCheckBox
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        App.formatter.dateFormat = "yyyy-MM-dd"
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        App.shiftFormatter.dateFormat = "hh:mma"
        App.shiftFormatter.amSymbol = "AM"
        App.shiftFormatter.pmSymbol = "PM"
        
        App.scheduleDisplayFormatter.dateFormat = "E MMM d, y"
        
        App.withSecondsFormatter.dateFormat = "hh:mm:ssa yyyy-MM-dd"
        
        FIRApp.configure()
    
        DB.ref = FIRDatabase.database().reference()
        DB.usersRef = DB.ref.child("users")
        DB.pendingUsersRef = DB.ref.child("pendingUsers")
        
        // Configure root view controller
        App.containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerView") as! ContainerViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = App.containerViewController
        window?.makeKeyAndVisible()
        
        setupTheme()

        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        print("\n\nTOKEN:\(token)\n\n")
        
        App.apnToken = token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage)
    }
    
    func setupTheme() {
        let shared = UIApplication.shared
        
        shared.delegate?.window??.tintColor = App.Theme.tintColor
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navbarbackgroundimage.jpg"), for: .default)
        
        UILabel.appearance().font = App.globalFont
    }
}

