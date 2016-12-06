//
//  ViewShiftTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVViewShiftTableViewController: UITableViewController {
    var schedule: GSSchedule!
    var day: GSDay!
    var shiftid: String!
    
    var positions: [String: String]!
    var positionids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positions = App.teamSettings.positions
        positionids = Array(positions.keys)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = positions[positionids[indexPath.row]]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVViewPosition" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let svViewPositionTableViewController = segue.destination as! SVViewPositionTableViewController
            svViewPositionTableViewController.schedule = schedule
            svViewPositionTableViewController.day = day
            svViewPositionTableViewController.shiftid = shiftid
            svViewPositionTableViewController.positionid = positionids[row]
        }
    }
}
