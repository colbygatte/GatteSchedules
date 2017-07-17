//
//  GSUserPosition.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/6/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class GSUserPosition: NSObject {
    var userDay: GSUserDay!
    var userShift: GSUserShift!
    var positionid: String!

    init(positionid: String) {
        self.positionid = positionid
    }
}
