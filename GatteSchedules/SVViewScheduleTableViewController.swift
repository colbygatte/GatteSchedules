//
//  ViewScheduleTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVViewScheduleTableViewController: UITableViewController {
    var schedule: GSSchedule!
    let week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = week[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVViewDay" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            if schedule.days.count - 1 >= row {
                let svViewDayTableViewController = segue.destination as! SVViewDayTableViewController
                svViewDayTableViewController.day = schedule.days[row]
            } else {
                print("ERROR")
            }
        } else if segue.identifier == "SEListDays" {
            let seListDaysTableViewController = segue.destination as! SEListDaysTableViewController
            seListDaysTableViewController.schedule = schedule
        }
    }
    
}
