//
//  SVDayTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/6/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVDayTableViewController: UITableViewController {
    var date: Date!
    var day: GSDay!
    var shifts: [String: String]!
    var shiftids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shifts = App.teamSettings.shiftNames
        shiftids = Array(shifts.keys)
        
        DB.get(day: date) { daySnap in
            if daySnap.childrenCount == 0 {
                print("does not exist")
                self.day = GSDay(date: self.date)
            } else {
                self.day = GSDay(snapshot: daySnap)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shifts[shiftids[indexPath.row]]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVShiftSegue" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            let shiftString = shiftids[row]
            let shift = day.get(shift: shiftString)
            
            let svShiftTableViewController = segue.destination as! SVShiftTableViewController
            svShiftTableViewController.shift = shift
        } else if segue.identifier == "SVEditButtonSegue" {
            let seIndexTableViewController = segue.destination as! SEIndexTableViewController
            seIndexTableViewController.day = day
        }
    }
}
