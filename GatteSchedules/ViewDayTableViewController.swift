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
    var shiftTitles: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shifts = day.getShifts()
        shiftTitles = Array(shifts.keys)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = shiftTitles[indexPath.row]
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewShift" {
            let viewShiftTableViewController = segue.destination as! ViewShiftTableViewController
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            viewShiftTableViewController.shiftData = ["shiftid": shiftTitles[row]]
            viewShiftTableViewController.workers = shifts[shiftTitles[row]]
        }
    }
}
