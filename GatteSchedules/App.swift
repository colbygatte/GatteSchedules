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
}
