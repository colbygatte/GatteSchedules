//
//  SEIndexTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEIndexTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var publishedSwitch: UISwitch!
    var day: GSDay!
    
    var shifts: [String: GSShift]!
    var shiftNames: [String: String]!
    var shiftids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        shifts = day.shifts
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shifts.keys)
        
        if day.published == true {
            publishedSwitch.isOn = true
        } else {
            publishedSwitch.isOn = false
        }
    }
    
    @IBAction func saveButtonPressed() {
        if publishedSwitch.isOn {
            day.published = true
        } else {
            day.published = false
        }
        DB.save(day: day)
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

extension SEIndexTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let shiftName = shiftNames[shiftids[row]]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shiftName
        return cell
    }
}


