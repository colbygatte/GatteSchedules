//
//  GSUsers.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/29/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase


class GSUser {
    var uid: String!
    
    var teamid: String!
    var name: String!
    var positions: [String]!
    var permissions: String!
    
    init(snapshot: FIRDataSnapshot, uid: String) {
        let values = snapshot.value as! [String: Any]
        self.uid = uid
        name = values["name"] as! String
        teamid = values["teamid"] as! String
        permissions = values["permissions"] as! String
        
        positions = []
        for position in values["positions"] as! [String] {
            positions.append(position)
        }
    }
}
