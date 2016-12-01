//
//  ViewDayTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class ViewDayTableViewController: UITableViewController {

    var day: GSDay!
    var shifts: [String: [GSWorker]]!
    var shiftids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shifts = day.getShifts()
        shiftids = Array(shifts.keys)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = App.teamSettings.shiftNames[shiftids[indexPath.row]]
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewShift" {
            let viewShiftTableViewController = segue.destination as! ViewShiftTableViewController
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            viewShiftTableViewController.shiftData = ["shiftid": shiftids[row]]
            viewShiftTableViewController.workers = shifts[shiftids[row]]
        }
    }
}
