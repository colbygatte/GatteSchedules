//
//  GSWorker.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class GSWorker: NSObject {
    var notes: String!
    var position: String!
    var shift: String!
    var uid: String!
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        uid = snapshot.key
        
        let values = snapshot.value as! [String: String]
        self.position = values["position"]
        self.shift = values["shift"]
        self.notes = values["notes"]
        
    }

    init(uid: String) {
        self.uid = uid
    }
    
    func toFirebaseObject() -> Any {
        var workerObject: [String: Any] = [:]
        
        workerObject["notes"] = notes
        workerObject["position"] = position
        workerObject["shift"] = shift
        
        return workerObject
    }
}
