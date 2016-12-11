//
//  GSDay.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class GSDay: NSObject {
    var date: Date!
    var notes: String!
    var published: Bool!
    var shifts: [String: GSShift]!
    
    func loadShifts() {
        for shiftData in App.teamSettings.shiftNames {
            let shift = GSShift(shiftid: shiftData.key, shiftName: shiftData.value)
            shifts[shiftData.key] = shift
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        date = App.formatter.date(from: snapshot.key)
        shifts = [:]
        loadShifts()
        
        for shiftData in snapshot.childSnapshot(forPath: "shifts").children {
            let shiftSnap = shiftData as! FIRDataSnapshot
            let shiftid = shiftSnap.key
            
            let shift = GSShift(snapshot: shiftSnap)
            shifts[shiftid] = shift
        }
        
        let publishedString = snapshot.childSnapshot(forPath: "published").value as? String
        
        if publishedString == "yes" {
            published = true
        } else {
            published = false
        }
    }
    
    init(date: Date) {
        super.init()
        self.date = date
        notes = "nil"
        shifts = [:]
        published = false
        loadShifts()
    }
    
    func toFirebaseObject() -> Any {
        var dayObject: [String: Any] = [:]
        
        dayObject["published"] = published == true ? "yes" : "no"
        
        var shiftsObject: [String: Any] = [:]
        for (shiftid, shift) in shifts {
            shiftsObject[shiftid] = shift.toFirebaseObject()
        }
        dayObject["shifts"] = shiftsObject
        
        return dayObject
    }
    
    func addDataFrom(snapshot: FIRDataSnapshot) {
        shifts = [:]
        loadShifts()
        
        for shiftData in snapshot.children {
            let shiftSnap = shiftData as! FIRDataSnapshot
            let shiftid = shiftSnap.key
            
            let shift = GSShift(snapshot: shiftSnap)
            shifts[shiftid] = shift
        }
    }

    
    func get(shift: String) -> GSShift {
        return shifts[shift]! // @@@@ handle errors here
    }
    
    func getWorkers(forShift: String, position: String) -> [GSUser] {
        return (shifts[forShift]?.positions[position]?.workers)!
    }
    
    func add(worker: GSUser, toShift: String, position: String) {
        get(shift: toShift).add(worker: worker, toPosition: position)
    }
    
    func remove(worker: GSUser, fromShift: String, position: String) {
        get(shift: fromShift).remove(worker: worker, fromPosition: position)
    }
}
