//
//  SVShiftTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVShiftTableViewController: UITableViewController {
    var day: GSDay!
    var shift: GSShift!
    
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
        let row = indexPath.row
        let text = positions[positionids[row]]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = text
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVPositionSegue" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            let positionid = positionids[row]
            let position = shift.get(position: positionid)
            
            let svPositionTableViewController = segue.destination as! SVPositionTableViewController
            svPositionTableViewController.day = day
            svPositionTableViewController.shift = shift
            svPositionTableViewController.position = position
        }
    }
}
