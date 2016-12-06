//
//  ViewShiftPositionTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/5/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVViewPositionTableViewController: UITableViewController {
    var schedule: GSSchedule!
    var day: GSDay!
    var shiftid: String!
    var positionid: String!
    
    var workers: [GSUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workers = day.getWorkers(forShift: shiftid, position: positionid)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = workers[indexPath.row].name
        return cell
    }
}
