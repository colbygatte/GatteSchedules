//
//  GSShift.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/5/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class GSShift: NSObject {
    var shiftid: String!
    var positions: [String: GSPosition]!
    
    func loadPositions() {
        positions = [:]
        let positionsData = App.teamSettings.positions
        for (positionid, _) in positionsData {
            let position = GSPosition(positionid: positionid)
            positions[positionid] = position
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        
        let shiftid = snapshot.key
        loadPositions()
        
        self.shiftid = shiftid
        
        for positionData in snapshot.children {
            let positionSnap = positionData as! FIRDataSnapshot
            let positionid = positionSnap.key
            
            let uids = positionSnap.value as! [String]
            
            for uid in uids {
                positions[positionid]?.add(worker: App.team.get(user: uid)!)
            }
        }
    }
    
    init(shiftid: String, shiftName: String) {
        super.init()
        
        self.shiftid = shiftid
        loadPositions()
    }
    
    func toFirebaseObject() -> Any {
        var shiftData: [String: Any] = [:]
        
        for (positionid, position) in positions {
            shiftData[positionid] = position.toFirebaseObject()
        }
        
        return shiftData
    }
    
    func add(worker: GSUser, toPosition: String, notes: String = "nil") {
        positions[toPosition]!.add(worker: worker, notes: notes)
    }
    
    func get(position: String) -> GSPosition {
        return positions[position]!
    }
    
}
