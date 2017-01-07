//
//  Global.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

struct App {
    static var formatter = DateFormatter()
    static var shiftFormatter = DateFormatter()
    static var scheduleDisplayFormatter = DateFormatter()
    static var withSecondsFormatter = DateFormatter()
    
    static var loggedIn: Bool = false
    static var loggedInUser: GSUser!
    static var team: GSTeam!
    static var teamSettings: GSSettings!
    
    static var now: Date = Date()
    static var apnToken: String?
    
    static var containerViewController: ContainerViewController!
    static var welcomeMessage: String? {
        didSet {
            App.containerViewController.menuTableViewController.label.text = welcomeMessage
            App.containerViewController.menuTableViewController.label.font = UIFont.boldSystemFont(ofSize: 22.0)
        }
    }
    
    static func setRefs(withTeamId: String) {
        DB.teamid = withTeamId
        DB.teamRef = DB.ref.child("teams").child(DB.teamid)
        DB.daysRef = DB.teamRef.child("days")
        DB.requestsRef = DB.teamRef.child("requests")
        DB.changesRef = DB.teamRef.child("changes")
        DB.tokensRef = DB.teamRef.child("tokens")
    }
    
    static func getDateFromNow(_ days: Int) -> Date {
        return App.now.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    }
    
    static func getDateFrom(_ date: Date, days: Int) -> Date {
        return date.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    }
    
    // Menu
    static var menuCells: [MenuCellData] = []
    
    static func toggleMenu() {
        App.containerViewController.toggleMenu()
    }
    
    static func refreshMenu() {
        App.containerViewController.menuTableViewController.tableView.reloadData()
    }
    
    static func clearMenu() {
        App.menuCells = []
    }
    
    static func mustBeManager(_ viewController: UIViewController?) {
        if App.loggedInUser.permissions != App.Permissions.manager {
            _ = viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    struct Permissions {
        static var manager = "manager"
        static var normal = "normal"
    }
    
    struct Theme {
        static var tintColor = UIColor.hexString(hex: "3D434E")
        static var navBarColor = UIColor.hexString(hex: "AEBCC9")
        
        static var menuBackgroundColor = UIColor.hexString(hex: "86919D")
        static var menuSeparatorColor = UIColor.hexString(hex: "FFFFFF")
        static var menuTextColor = UIColor.hexString(hex: "FFFFFF")
        
        static var bemCheckboxOffColor = UIColor.gray
        static var bemCheckboxOnColor = UIColor.hexString(hex: "2C3849")
    }
    
    static func makeMenu() {
        App.clearMenu()
        
        if App.loggedInUser.permissions == App.Permissions.manager {
            let userMb = MenuCellData(text: "Users", block: {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ViewUsers")
                App.containerViewController.containerNavigationController.pushViewController(vc, animated: true)
            })
            App.menuCells.append(userMb)
            
            let pendingUsersMb = MenuCellData(text: "Pending users", block: {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ViewPendingUsers")
                App.containerViewController.containerNavigationController.pushViewController(vc, animated: true)
            })
            App.menuCells.append(pendingUsersMb)
            
            let mb1 = MenuCellData(text: "Settings", block: {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Settings")
                App.containerViewController.containerNavigationController.pushViewController(vc, animated: true)
            })
            App.menuCells.append(mb1)
        }
        
        let logoutMenuButton = MenuCellData(text: "Logout", block: {
            DB.signOut {
                App.loggedIn = false
            }
        })
        App.menuCells.append(logoutMenuButton)
        App.refreshMenu()
    }
    
    static func loadBasicData() {
        
    }
}

extension String {
    static func random(length: Int) -> String {
        let l = "0123456789abcdefghijklmnopqrstuvwxyz" // only lowercase, we want case insensitive
        let letters = Array(l.characters)
        var randString = ""
        for _ in 1...length {
            randString += String(letters[Int(arc4random_uniform(36))])
        }
        return randString
    }
}

// below from http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
extension UIColor {
    static func hexString(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
