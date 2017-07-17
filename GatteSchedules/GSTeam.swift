//
//  GSTeam.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation

class GSTeam: NSObject {
    var teamUsers = [String: GSUser]()

    var allUids: [String] {
        return Array(teamUsers.keys)
    }

    func get(nameFromUid uid: String) -> String {
        return teamUsers[uid]!.name // @@@@ better error handling
    }

    func add(user: GSUser) {
        teamUsers[user.uid] = user
    }

    func get(user: String) -> GSUser? { // @@@@ doesn't check to see if user exists
        return teamUsers[user]
    }

    func getUsersWhoCanWork(position: String) -> [GSUser] {
        return teamUsers.values.filter { $0.canDo(shift: position) }
    }
}
