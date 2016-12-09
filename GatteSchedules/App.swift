//
//  Global.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation

struct App {
    static var formatter = DateFormatter()
    static var shiftFormatter = DateFormatter()
    
    static var loggedIn: Bool = false
    static var loggedInUser: GSUser!
    static var team: GSTeam!
    static var teamSettings: GSSettings!
    
    static var now: Date = Date()
    
    static var containerViewController: ContainerViewController!
    
    static func getDateFromNow(_ days: Int) -> Date {
        return App.now.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    }
    
    static var menuCells: [MenuCellData] = []
    
    static func toggleMenu() {
        App.containerViewController.toggleMenu()
    }
    
    static func refreshMenu() {
        App.containerViewController.menuTableViewController.tableView.reloadData()
    }
    
    enum Controllers {
        case settings
    }
    
    struct Theme {
        
    }
}

extension String {
    static func random(length: Int) -> String {
        let l = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letters = Array(l.characters)
        var randString = ""
        for _ in 1...length {
            randString += String(letters[Int(arc4random_uniform(62))])
        }
        return randString
    }
}
