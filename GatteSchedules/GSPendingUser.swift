//
//  GSPendingUser.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/3/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class GSPendingUser: NSObject {
    var name: String!
    
    var email: String!
    
    var teamid: String!
    
    var code: String!

    init(snapshot: FIRDataSnapshot) {
        code = snapshot.key

        guard let values = snapshot.value as? [String: String] else {
            return // TODO: error handling
        }
        
        email = values["email"]
        name = values["name"]
        teamid = values["teamid"]
    }
}
