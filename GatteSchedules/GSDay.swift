//
//  GSDay.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

struct GSDayShiftData {
    var positionid: String
    var shiftid: String
}

class GSDay: NSObject {
    var date: Date!
    var notes: String!
    var published: Bool!
    var shifts: [String: GSShift]!
    var allWorkers: [String: [GSDayShiftData]]! // [uid: []]
    
    func loadShifts() {
        for shiftData in App.teamSettings.shiftNames {
            let shift = GSShift(shiftid: shiftData.key, day: self)
            shifts[shiftData.key] = shift
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        allWorkers = [:]
        date = App.formatter.date(from: snapshot.key)
        shifts = [:]
        loadShifts()
        
        for shiftData in snapshot.childSnapshot(forPath: "shifts").children {
            let shiftSnap = shiftData as! FIRDataSnapshot
            let shiftid = shiftSnap.key
            
            let shift = GSShift(snapshot: shiftSnap, day: self)
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
        allWorkers = [:]
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
            
            let shift = GSShift(snapshot: shiftSnap, day: self)
            shifts[shiftid] = shift
        }
    }

    func isWorking(uid: String, shift: String) -> GSDayShiftData? {
        if let userShiftsData = allWorkers[uid] {
            for userShiftData in userShiftsData {
                if userShiftData.shiftid == shift {
                    return userShiftData
                }
            }
        }
        return nil
    }
    
/*    func checkOverlappingShifts() {
        for (worker, shiftsData) in allWorkers {
            for shift in shiftsData {
                let shiftDates = App.teamSettings.getShiftDates(id: shift.shiftid)
                
            }
        }
    }*/
    
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

extension GSDay: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GSDay(date: date)
        copy.allWorkers = allWorkers
        copy.published = published
        
        for (shiftid, shift) in shifts {
            shift.copyDay = copy
            copy.shifts[shiftid] = (shift.copy() as! GSShift)
        }
        
        return copy
    }
}
