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
    var requests: [GSUserDayRequest]!
    
    override init() {
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        let dateString = snapshot.key
        date = App.formatter.date(from: dateString)
        
        for requestData in snapshot.children {
            let requestSnap = requestData as! FIRDataSnapshot
            let request = GSUserDayRequest(snapshot: requestSnap)
            requests.append(request)
        }
    }
    
    func toFirebaseObject() -> Any {
        var requestsObject = [String: Any]()
        for request in requests {
            requestsObject[request.user.uid] = request.toFirebaseObject()
        }
        
        return requestsObject
    }
}
