//
//  SettingsViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ViewPositions":
            let positionsTableViewController = segue.destination as! PositionsTableViewController
            break
        case "ViewShifts":
            break
        default:
            break
        }
    }
}
