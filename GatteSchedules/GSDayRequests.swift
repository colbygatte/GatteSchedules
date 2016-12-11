//
//  GSRequests.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/29/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

// Handles all requests for a given day
class GSDayRequests: NSObject {
    var date: Date!
    var requests: [GSUserRequests]!
    
    init(snapshot: FIRDataSnapshot) {
        let dateString = snapshot.key
        date = App.formatter.date(from: dateString)
        
        for requestData in snapshot.children {
            let requestSnap = requestData as! FIRDataSnapshot
            let request = GSUserRequests(snapshot: requestSnap)
            requests.append(request)
        }
    }
    
    func toFirebaseObject() -> Any {
        
        return ""
    }
}
