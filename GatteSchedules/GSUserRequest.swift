//
//  GSRequest.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

enum GSRequestStatus {
    case pending, granted
}

enum GSRequesting {
    case on, off
}

struct GSRequestData {
    var shiftid: String
    var request: GSRequesting
}

class GSUserRequests: NSObject {
    var status: GSRequestStatus!
    var user: GSUser!
    var requests: [GSRequestData]!

    init(snapshot: FIRDataSnapshot) {
        
    }
    
    func toFirebaseObject() -> Any {
        
        return ""
    }
}
