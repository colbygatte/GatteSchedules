//
//  Global.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

struct App {
    static var formatter = DateFormatter()
    static var shiftFormatter = DateFormatter()
    static var scheduleDisplayFormatter = DateFormatter()
    
    static var loggedIn: Bool = false
    static var loggedInUser: GSUser!
    static var team: GSTeam!
    static var teamSettings: GSSettings!
    
    static var now: Date = Date()
    
    static var containerViewController: ContainerViewController!
    
    static func getDateFromNow(_ days: Int) -> Date {
        return App.now.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
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
}

extension String {
    static func random(length: Int) -> String {
        let l = "0123456789abcdefghijklmnopqrstuvwxyz" // only lowercase, we want case insensitive
        let letters = Array(l.characters)
        var randString = ""
        for _ in 1...length {
            randString += String(letters[Int(arc4random_uniform(62))])
        }
        return randString
    }
}
