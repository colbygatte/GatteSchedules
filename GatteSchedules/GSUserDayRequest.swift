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

struct GSUserRequestData {
    var shiftid: String
    var requesting: String
}

class GSUserDayRequest: NSObject {
    var status: GSUserRequestStatus!
    var uid: String!
    var requests: [GSUserRequestData]!
    var requestDayOff: Bool = false

    override init() {
        requests = []
    }

    init(snapshot: FIRDataSnapshot) {
        requests = []
        uid = snapshot.key
        let values = snapshot.value as? [String: String]

        if values != nil { // @@@@ check to see if this works
            if values!["all-day"] != nil {
                requestDayOff = true
            }

            for userRequestShiftData in values! {
                let userRequestData = GSUserRequestData(shiftid: userRequestShiftData.key, requesting: userRequestShiftData.value)
                requests.append(userRequestData)
            }
        }
    }

    func requestFor(shift: String) -> String? {
        for request in requests {
            if request.shiftid == shift {
                return request.requesting
            }
        }
        return nil
    }

    func toFirebaseObject() -> Any {
        var userRequestObject = [String: String]()
        for userRequest in requests {
            userRequestObject[userRequest.shiftid] = userRequest.requesting
        }
        if requestDayOff {
            userRequestObject["all-day"] = "off"
        } else {
            if let _ = userRequestObject["all-day"] {
                userRequestObject["all-day"] = nil
            }
        }
        return userRequestObject
    }
}
