//
//  GSSchedule.swift
//  
//
//  Created by Colby Gatte on 11/28/16.
//
//

import UIKit
import Firebase

class GSSchedule: NSObject {
    var ref: FIRDatabaseReference!
    var days: [GSDay]!
    var createdBy: String!
    var dateCreated: Date!
    var lastEdited: Date!
    var startDate: Date!
    var notes: String!
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        ref = snapshot.ref
        startDate = App.formatter.date(from: snapshot.key)
        days = []
        
        if snapshot.childrenCount == 0 {
            print("error!")
        }
        
        let info = snapshot.childSnapshot(forPath: "info").value as! [String: String]
        createdBy = info["createdBy"]
        dateCreated = App.formatter.date(from: info["dateCreated"]!)
        lastEdited = App.formatter.date(from: info["lastEdited"]!)
        
        createDays(starting: startDate)
        
        let daysSnapshot = snapshot.childSnapshot(forPath: "days")
        for dayData in daysSnapshot.children {
            let daySnap = dayData as! FIRDataSnapshot
            let dayIndex = days.index(where: { day in
                App.formatter.string(from: day.date) == daySnap.key
            })
            let day = days[dayIndex!]
            
            day.addDataFrom(snapshot: daySnap)
        }
        
        sortDays()
    }
    
    init(firebaseRef: FIRDatabaseReference, createdBy: String) {
        super.init()
        
        ref = firebaseRef
        self.createdBy = createdBy
        self.startDate = App.formatter.date(from: firebaseRef.key)
        dateCreated = Date()
        lastEdited = Date()
        notes = "nil"
        days = []
        
        createDays(starting: startDate)
    }
    
    func createDays(starting: Date) {
        // only supports 7 day week schedules for now
        for i in 0...6 {
            let add = 60 * 60 * 24 * i
            let day = GSDay(date: starting.addingTimeInterval(TimeInterval(add)))
            days.append(day)
        }
    }
    
    func toFirebaseObject() -> Any {
        let infoObject: [String: String] = [
            "createdBy": createdBy,
            "dateCreated": App.formatter.string(from: dateCreated),
            "lastEdited": App.formatter.string(from: lastEdited),
            "locked": "false"
        ]
        
        var daysObject: [String: Any] = [:]
        for day in days {
            let dayDateString = App.formatter.string(from: day.date)
            let dayObject = day.toFirebaseObject()
            daysObject[dayDateString] = dayObject
        }
        
        return ["info": infoObject, "days": daysObject]
    }
    
    func sortDays() {
        days.sort { (day1, day2) in
            day1.date.compare(day2.date) == ComparisonResult.orderedAscending
        }
    }
    
    func day(_ index: Int) -> GSDay? {
        if days.count - 1 >= index {
            return days[index]
        } else {
            return nil
        }
    }
}
