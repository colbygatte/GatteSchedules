//
//  GSRequest.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

enum GSUserRequestStatus {
    case pending, granted, denied
}

enum GSUserRequesting {
    case on, off
}

struct GSUserRequestData {
    var shiftid: String
    var requesting: GSUserRequesting
}

class GSUserDayRequest: NSObject {
    var status: GSUserRequestStatus!
    var user: GSUser!
    var requests: [GSUserRequestData]!

    override init() {
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        
    }
    
    func toFirebaseObject() -> Any {
        var userRequestObject = [String: String]()
        for userRequest in requests {
            let requesting: String
            switch userRequest.requesting {
            case .on:
                requesting = "on"
                break;
            case .off:
                requesting = "off"
                break;
            }
            
            userRequestObject[userRequest.shiftid] = requesting
        }
        return userRequestObject
    }
}
