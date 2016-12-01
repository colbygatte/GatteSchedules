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
        
        FIRApp.configure()
    
        DB.usersRef = FIRDatabase.database().reference().child("users")
        
        return true
    }
    
}

