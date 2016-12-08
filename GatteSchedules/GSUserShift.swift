//
//  GSUserShift.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/6/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class GSUserShift: NSObject {
    var userDay: GSUserDay!
    var shiftid: String!

    var position: GSUserPosition!
    
    init(shiftid: String, positionid: String) {
        super.init()
        
        position = GSUserPosition(positionid: positionid)
        position.userDay = userDay
        position.userShift = self
        
        self.shiftid = shiftid
    }
}
