//
//  DDIndexViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/9/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class DDIndexViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var userDay: GSUserDay!
    var day: GSDay?
    
    var shiftNames: [String: String]!
    var shiftids: [String]!
    var positionNames: [String: String]!
    var positionids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
        positionNames = App.teamSettings.positions
        positionids = Array(positionNames.keys)
        
        DB.get(day: userDay.date) { snap in
            self.day = GSDay(snapshot: snap)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DDWorkers" {
            let indexPath = (tableView.indexPathForSelectedRow)!
            let positionid = positionids[indexPath.row]
            
            let vc = segue.destination as! DDScheduleForPositionViewController
            vc.positionid = positionid
            vc.userDay = userDay
        } else if segue.identifier == "DDEdit" {
            let vc = segue.destination as! SEIndexTableViewController
            vc.day = day! // @@@@ error handle, check for day first
        }
    }
}

// MARK: Table View

extension DDIndexViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let positionName = positionNames[positionids[indexPath.row]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = positionName
        return cell
    }
}
