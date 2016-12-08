//
//  SEIndexTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEIndexTableViewController: UITableViewController {
    var day: GSDay!
    
    var shifts: [String: GSShift]!
    var shiftNames: [String: String]!
    var shiftids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shifts = day.shifts
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shifts.keys)
    }
    
    @IBAction func saveButtonPressed() {
        DB.save(day: day)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let shiftName = shiftNames[shiftids[row]]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shiftName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SEShiftSegue" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            let shift = shifts[shiftids[row]]
            
            let seShiftTableViewController = segue.destination as! SEShiftTableViewController
            seShiftTableViewController.day = day
            seShiftTableViewController.shift = shift
        }
    }
}
