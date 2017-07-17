//
//  Global.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//
/* == OpenSans-Semibold
 == OpenSans-Light
 == OpenSans
 */

import UIKit
import Firebase

func __(_ text: String) -> String {
    return text
}

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

    static var fontSize: CGFloat = 16.0

    static var globalFont = UIFont(name: "OpenSans-Light", size: 16.0)
    static var globalFontThick = UIFont(name: "OpenSans", size: 17.0)
    static var globalFontThicker = UIFont(name: "OpenSans-Semibold", size: 24.0)

    static var containerViewController: ContainerViewController!
    static var welcomeMessage: String? {
        didSet {
            App.containerViewController.menuTableViewController.label.text = welcomeMessage
            App.containerViewController.menuTableViewController.label.font = App.globalFontThicker
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
        static var tintColor = UIColor.hexString(hex: "414141")

        static var menuBackgroundColor = UIColor.hexString(hex: "EAEAEA")
        static var menuTextColor = UIColor.hexString(hex: "494949")
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

extension UIBarButtonItem {
    func gsSetFont() {
        self.setTitleTextAttributes([NSFontAttributeName: App.globalFontThicker?.withSize(17)], for: .normal)
    }
}

extension UIViewController {
    func quickAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
    }

    func gsSetupNavBar() {
        if let bs = navigationItem.leftBarButtonItems {
            for b in bs {
                b.gsSetFont()
            }
        }

        if let bs = navigationItem.rightBarButtonItems {
            for b in bs {
                b.gsSetFont()
            }
        }
    }
}

extension UITableView {
    func registerGSTableViewCell() {
        self.register(UINib(nibName: "GSTableViewCell", bundle: nil), forCellReuseIdentifier: "GSCell")
    }

    func dequeueGSTableViewCell() -> GSTableViewCell {
        return self.dequeueReusableCell(withIdentifier: "GSCell") as! GSTableViewCell
    }

    func registerGSSubtitleTableViewCell() {
        self.register(UINib(nibName: "GSSubtitleTableViewCell", bundle: nil), forCellReuseIdentifier: "GSCell")
    }

    func dequeueGSSubtitleTableViewCell() -> GSSubtitleTableViewCell {
        return self.dequeueReusableCell(withIdentifier: "GSCell") as! GSSubtitleTableViewCell
    }
}

extension String {
    static func random(length: Int) -> String {
        let l = "0123456789" // only lowercase, we want case insensitive
        let letters = Array(l.characters)
        var randString = ""
        for _ in 1 ... length {
            randString += String(letters[Int(arc4random_uniform(10))])
        }
        return randString
    }
}

// below from http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
extension UIColor {
    static func hexString(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.characters.count) != 6 {
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
