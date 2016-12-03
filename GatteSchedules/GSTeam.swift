//
//  GSTeam.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation

class GSTeam: NSObject {
    var teamUsers: [String: GSUser]!
    
    override init() {
        teamUsers = [:]
    }
    
    var allUids: [String] {
        return Array(teamUsers.keys)
    }
    
    func add(user: GSUser) {
        teamUsers[user.uid] = user
    }
    
    func get(user: String) -> GSUser? { // @@@@ doesn't check to see if user exists
        return teamUsers[user]
    }
}
