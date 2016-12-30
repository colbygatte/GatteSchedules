//
//  GSSettings.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

struct GSShiftDates {
    var begin: Date
    var end: Date
}

class GSSettings: NSObject {
    var shifts: [String: [Date]] // shiftid: dates
    var shiftNames: [String: String] // shiftid: name
    var positions: [String: String]
    var teamName: String!
    var teamid: String!
    var daysPriorRestriction: Int!
    
    init(snapshot: FIRDataSnapshot) {
        shifts = [:]
        positions = [:]
        shiftNames = [:]
        super.init()
        
        let settingsObject = snapshot.value as! [String: Any]
        
        teamName = settingsObject["teamName"] as! String
        teamid = DB.teamRef.key
        
        if snapshot.hasChild("daysPriorRestriction") {
            daysPriorRestriction = settingsObject["daysPriorRestriction"] as! Int
        } else {
            daysPriorRestriction = 5
        }
        
        if snapshot.hasChild("positions") {
            let positionsObject = settingsObject["positions"] as! [String: String]
            for (positionid, positionTitle) in positionsObject {
                positions[positionid] = positionTitle
            }
        }
        
        if snapshot.hasChild("shifts") {
            let shiftsObject = settingsObject["shifts"] as! [String: [String: String]]
            for (shiftid, shiftData) in shiftsObject {
                let date1 = App.shiftFormatter.date(from: shiftData["begin"]!)
                let date2 = App.shiftFormatter.date(from: shiftData["end"]!)
                shifts[shiftid] = [date1!, date2!]
                shiftNames[shiftid] = shiftData["name"]
            }
        }
    }
    
    func toFirebaseObject() -> Any {
        var settingsObject: [String: Any] = [:]
        
        settingsObject["teamName"] = teamName
        settingsObject["teamid"] = teamid
        settingsObject["daysPriorRestriction"] = daysPriorRestriction
        
        var shiftsObject: [String: [String:String]] = [:]
        for (shiftid, shiftTimes) in shifts {
            let begin = App.shiftFormatter.string(from: shiftTimes[0])
            let end = App.shiftFormatter.string(from: shiftTimes[1])
            let name = shiftNames[shiftid]
            
            shiftsObject[shiftid] = ["begin": begin, "end": end, "name": name!]
        }
        settingsObject["shifts"] = shiftsObject
        
        var positionsObject: [String: String] = [:]
        for (positionid, positionName) in positions {
            positionsObject[positionid] = positionName
        }
        settingsObject["positions"] = positionsObject
        
        return settingsObject
    }
    
    func addShift(name: String, id: String) {
        let begin = App.shiftFormatter.date(from: "09:00AM")
        let end = App.shiftFormatter.date(from: "05:00PM")
        
        shifts[id] = [begin!, end!]
        shiftNames[id] = name
    }
    
    func editShift(id: String, dates: GSShiftDates) {
        shifts[id]?[0] = dates.begin
        shifts[id]?[1] = dates.end
    }
    
    func getShiftNames() -> [String: String] {
        return shiftNames
    }
    
    func getShiftDates(id: String) -> GSShiftDates {
        let begin = shifts[id]?[0]
        let end = shifts[id]?[1]
        return GSShiftDates(begin: begin!, end: end!)
    }
    
    func getShiftIds() -> [String] {
        return Array(shiftNames.keys)
    }
    
    func getShift(id: String) -> String? {
        return shiftNames[id]
    }
    
    func getPositionIds() -> [String] {
        return Array(positions.keys)
    }
    
    func addPosition(name: String, id: String) {
        positions[id] = name
    }
    
    func getPosition(id: String) -> String? {
        return positions[id]
    }
}
