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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        App.formatter.dateFormat = "yyyy-MM-dd"
        
        App.shiftFormatter.dateFormat = "hh:mma"
        App.shiftFormatter.amSymbol = "AM"
        App.shiftFormatter.pmSymbol = "PM"
        
        App.scheduleDisplayFormatter.dateFormat = "E MMM d, y"
        
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
        
        return true
    }
    
    func setupTheme() {
        let shared = UIApplication.shared
        shared.delegate?.window??.tintColor = UIColor.gray
        
        //UINavigationBar.appearance().backgroundColor = UIColor.brown
    }
}

