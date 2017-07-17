//
//  GSUsers.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/29/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

class GSUser: NSObject {
    var uid: String!
    
    var apnTokens = [String]()

    var teamid: String!
    
    var name: String!
    
    var email: String!
    
    var positions = [String]() // workable positions
    
    var shifts = [String]() // workable shifts
    
    var permissions: String!

    init(snapshot: FIRDataSnapshot, uid: String) {
        let values = snapshot.value as! [String: Any]
        
        self.uid = uid
        
        name = values["name"] as! String
        teamid = values["teamid"] as! String
        permissions = values["permissions"] as! String
        email = values["email"] as! String

        if let tokens = values["apnTokens"] as? [String]{
            apnTokens = tokens
        }

        if let positionsValues = values["positions"] as? [String]{
            for position in positionsValues {
                positions.append(position)
            }
        }

        if let shiftsValues = values["shifts"] as? [String] {
            for shift in shiftsValues {
                shifts.append(shift)
            }
        }
    }

    init(uid: String, email: String, name: String, teamid: String, permissions: String, positions: [String], shifts: [String]) {
        self.uid = uid
        self.email = email
        self.name = name
        self.teamid = teamid
        self.permissions = permissions
        self.positions = positions
        self.shifts = shifts
    }

    func toFirebaseObject() -> Any {
        return [
            "name": name,
            "permissions": permissions,
            "teamid": teamid,
            "positions": positions,
            "shifts": shifts,
            "email": email,
            "apnTokens": apnTokens
        ]
    }

    func canDo(position: String) -> Bool {
        return positions.contains(position)
    }

    func canDo(shift: String) -> Bool {
        return shifts.contains(shift)
    }
}
