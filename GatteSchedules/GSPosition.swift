//
//  GSPosition.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/5/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class GSPosition: NSObject {
    var copyShift: GSShift?
    var copyDay: GSDay?
    var day: GSDay!
    var shift: GSShift!
    var positionid: String!
    var shiftid: String!
    var workers: [GSUser]!
    var notes: [String: String]!
    
    init(positionid: String, shift: GSShift, day: GSDay) {
        self.shift = shift
        self.day = day
        self.positionid = positionid
        
        notes = [:]
        workers = []
    }
    
    func toFirebaseObject() -> Any {
        var positionData: [String] = []
        
        for user in workers {
            positionData.append(user.uid)
        }
        
        return positionData
    }
    
    func getWorkersDictionary() -> [String: GSUser] {
        var workersDic: [String: GSUser] = [:]
        
        for worker in workers {
            workersDic[worker.uid] = worker
        }
        
        return workersDic
    }
    
    func add(worker: GSUser, notes: String = "nil") {
        if day.allWorkers[worker.uid] == nil {
            day.allWorkers[worker.uid] = []
        }
        day.allWorkers[worker.uid]!.append(GSDayShiftData(positionid: positionid, shiftid: shift.shiftid))
        
        //let uid = worker.uid
        workers.append(worker)
        
        //notes[uid!] = notes // @@@@< why is this giving an error?
    }
    
    func remove(worker: GSUser) {
        if day.allWorkers[worker.uid] != nil {
            let index = day!.allWorkers[worker.uid]?.index(where: { (shiftData: GSDayShiftData) in
                (shiftData.positionid == positionid && shiftData.shiftid == shift.shiftid)
            })
            
            if index != nil {
                day.allWorkers[worker.uid]!.remove(at: index!)
            }
        }
        
        let index = workers.index(of: worker)
        if index != nil {
            workers.remove(at: index!)
        }
    }
}

extension GSPosition: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GSPosition(positionid: positionid, shift: copyShift!, day: copyDay!)
        return copy
    }
}
