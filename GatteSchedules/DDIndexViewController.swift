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
        tableView.delegate = self
        tableView.dataSource = self
        
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
        positionNames = App.teamSettings.positions
        positionids = Array(positionNames.keys)
    }
    
    // Called after the day has been loaded and given to us
    func didLoadDay() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DDWorkers" {
            let indexPath = (tableView.indexPathForSelectedRow)!
            let shiftid = shiftids[indexPath.section]
            let positionid = positionids[indexPath.row]
            let workers = day?.getWorkers(forShift: shiftid, position: positionid)
            
            let vc = segue.destination as! DDWorkersViewController
            vc.workers = workers
            vc.shiftid = shiftid
            vc.positionid = positionid
        }
    }
}

// MARK: Table View

extension DDIndexViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return shiftids.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shiftNames[shiftids[section]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if day == nil {
            return 0
        } else {
            let shiftid = shiftids[section]
            let shift = day!.get(shift: shiftid)
            return shift.positions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let positionName = positionNames[positionids[indexPath.row]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = positionName
        return cell
    }
}
