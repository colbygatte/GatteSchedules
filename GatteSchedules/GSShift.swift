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
    var day: GSDay!
    var shiftid: String!
    var positions: [String: GSPosition]!
    
    func loadPositions() {
        positions = [:]
        let positionsData = App.teamSettings.positions
        for (positionid, _) in positionsData {
            let position = GSPosition(positionid: positionid, shift: self, day: day)
            position.day = day
            position.shift = self
            positions[positionid] = position
        }
    }
    
    init(snapshot: FIRDataSnapshot, day: GSDay) {
        super.init()
        self.day = day
        
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
    
    init(shiftid: String, day: GSDay) {
        super.init()
        self.day = day
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
    
    func remove(worker: GSUser, fromPosition: String) {
        positions[fromPosition]!.remove(worker: worker)
    }
    
    func get(position: String) -> GSPosition {
        return positions[position]!
    }
    
}
