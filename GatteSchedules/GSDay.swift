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
    var schedule: GSSchedule!
    var date: Date!
    var notes: String!
    var shifts: [String: GSShift]!
    
    func loadShifts() {
        for shiftData in App.teamSettings.shiftNames {
            let shift = GSShift(shiftid: shiftData.key, shiftName: shiftData.value)
            shifts[shiftData.key] = shift
        }
    }
    
    init(snapshot: FIRDataSnapshot, belongsToSchedule: GSSchedule) {
        super.init()
        schedule = belongsToSchedule
        date = App.formatter.date(from: snapshot.key)
        shifts = [:]
        loadShifts()
        
        for shiftData in snapshot.children {
            let shiftSnap = shiftData as! FIRDataSnapshot
            let shiftid = shiftSnap.key
            
            let shift = GSShift(snapshot: shiftSnap)
            shifts[shiftid] = shift
        }
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
    
    init(date: Date) {
        super.init()
        self.date = date
        notes = "nil"
        shifts = [:]
        loadShifts()
    }

    func toFirebaseObject() -> Any {
        var dayObject: [String: Any] = [:]
        
        for (shiftid, shift) in shifts {
            dayObject[shiftid] = shift.toFirebaseObject()
        }
        
        return dayObject
    }
    
    func get(shift: String) -> GSShift {
        return shifts[shift]! // @@@@ handle errors here
    }
    
    func getWorkers(forShift: String, position: String) -> [GSUser] {
        return (shifts[forShift]?.positions[position]?.workers)!
    }
    
    func addWorker(toShift: String, position: String) {
        
    }
    
    func removeWorker(fromShift: String, position: String) {
        
    }
}
