//
//  TestViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/6/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DB.getSchedule(schedule: "2016-11-20") { snap in
            let schedule = GSSchedule(snapshot: snap)
            let userSchedule = GSUserSchedule(uid: "LOgh8Yb36RZYvsLcjZNvh3n97yl1", schedule: schedule)
        }
    }
}
