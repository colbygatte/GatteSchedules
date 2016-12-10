//
//  GSPosition.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/5/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class GSPosition: NSObject {
    var positionid: String!
    var workers: [GSUser]!
    var notes: [String: String]!
    
    init(positionid: String) {
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
        let uid = worker.uid
        workers.append(worker)
        //notes[uid!] = notes // @@@@< why is this giving an error?
    }
    
    func remove(worker: GSUser) {
        let index = workers.index { $0 === worker }
        if index != nil {
            workers.remove(at: index!)
        }
    }
    
    // @@@@ finish
    func isWorking(user: GSUser) {
        
    }
}
