//
//  GSSettings.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class GSSettings: NSObject {
    var shifts: [String: [Date]]
    var positions: [String: String]
    var teamName: String!
    var teamid: String!
    
    init(snapshot: FIRDataSnapshot) {
        shifts = [:]
        positions = [:]
        super.init()
        
        let settingsObject = snapshot.value as! [String: Any]
        
        teamName = settingsObject["teamName"] as! String
        teamid = settingsObject["teamid"] as! String
        
        let positionsObject = settingsObject["positions"] as! [String: String]
        for (positionid, positionTitle) in positionsObject {
            positions[positionid] = positionTitle
        }
        
        let shiftsObject = settingsObject["shifts"] as! [String: [String]]
        for (shiftid, shiftHours) in shiftsObject {
            let date1 = App.shiftFormatter.date(from: shiftHours[0])
            let date2 = App.shiftFormatter.date(from: shiftHours[1])
            shifts[shiftid] = [date1!, date2!]
        }
    }
}
