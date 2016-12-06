//
//  ListSchedulesTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/29/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class SVListSchedulesTableViewController: UITableViewController {
    var schedules: [GSSchedule]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedules = []
        
        DB.getSchedules() { shedulesSnapshot in
            for scheduleData in shedulesSnapshot.children {
                let scheduleSnapshot = scheduleData as! FIRDataSnapshot
                let schedule = GSSchedule(snapshot: scheduleSnapshot)
                self.schedules.append(schedule)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let schedule = schedules[indexPath.row]
        let day = schedule.day(0)
        let dateText: String
        if day != nil {
            dateText = App.formatter.string(from: (schedule.day(0)?.date)!)
        } else {
            dateText = App.formatter.string(from: schedule.startDate)
        }
        
        cell.textLabel?.text = dateText
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVViewSchedule" {
            let svViewScheduleTableViewController = segue.destination as! SVViewScheduleTableViewController
            let schedule = schedules[(tableView.indexPathForSelectedRow?.row)!]
            svViewScheduleTableViewController.schedule = schedule
        }
    }
}

