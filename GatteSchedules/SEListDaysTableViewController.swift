//
//  ScheduleMakerListDaysTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEListDaysTableViewController: UITableViewController {
    var schedule: GSSchedule!
    var week: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        navigationItem.hidesBackButton = true
        let customBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed(sender:)))
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    // Table
    func backButtonPressed(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = week[indexPath.row]
        
        return cell
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SEEditDay" {
            let seEditDayTableViewController = segue.destination as! SEEditDayTableViewController
            seEditDayTableViewController.schedule = schedule
            seEditDayTableViewController.dayIndex = (tableView.indexPathForSelectedRow?.row)!
        }
    }
}
