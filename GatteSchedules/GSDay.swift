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
    var workers: [GSWorker]!
    var notes: String!
    
    init(snapshot: FIRDataSnapshot, belongsToSchedule: GSSchedule) {
        super.init()
        schedule = belongsToSchedule
        date = App.formatter.date(from: snapshot.key)
        workers = []
        
        let notesSnapshot = snapshot.childSnapshot(forPath: "notes")
        notes = notesSnapshot.value as! String
        
        let workersSnapshot = snapshot.childSnapshot(forPath: "workers")
        
        for workerData in workersSnapshot.children {
            let workerSnapshot = workerData as! FIRDataSnapshot
            let worker = GSWorker(snapshot: workerSnapshot)
            workers.append(worker)
        }
        
    }
    
    init(date: Date) {
        self.date = date
        workers = []
        notes = "nil"
    }

    func toFirebaseObject() -> Any {
        var workersObject: [String: Any] = [:]
        for worker in workers {
            workersObject[worker.uid] = worker.toFirebaseObject()
        }
        workersObject["notes"] = notes
        return workersObject
    }
    
    func getShifts() -> [String: [GSWorker]] {
        var shifts: [String: [GSWorker]] = [:]
        for worker in workers {
            if shifts[worker.shift] == nil {
                shifts[worker.shift] = []
            }
            shifts[worker.shift]?.append(worker)
        }
        
        return shifts
    }
    
}
