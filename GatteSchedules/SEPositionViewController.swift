//
//  SEPositionViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEPositionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var day: GSDay!
    var positionid: String!
    
    var shiftNames: [String: String]!
    var shiftids: [String]!
    var workers: [String: [GSUser]]! // shiftid: users
    var possibleWorkers: [GSUser]! // all workers who can work this shift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        possibleWorkers = App.team.getUsersWhoCanWork(position: positionid)
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
        workers = [:]
        
        var sectionIndex = 0
        for shiftid in shiftids {
            let shift = day!.get(shift: shiftid)
            let thisPosition = shift.get(position: self.positionid)
            let workers = thisPosition.workers
            
            self.workers[shiftid] = workers
            
            // select the rows where the workers are working
            for worker in self.workers[shiftid]! {
                let rowIndex = possibleWorkers.index(of: worker)
                let indexPath = IndexPath(row: rowIndex!, section: sectionIndex)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            sectionIndex += 1
        }
    }
}

extension SEPositionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return shiftids.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shiftNames[shiftids[section]]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleWorkers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = possibleWorkers[indexPath.row].name
        return cell
    }
}

extension SEPositionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shiftid = shiftids[indexPath.section]
        let user = possibleWorkers[indexPath.row]
        
        day.add(worker: user, toShift: shiftid, position: positionid)
        workers[shiftid]?.append(user)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let shiftid = shiftids[indexPath.section]
        let user = possibleWorkers[indexPath.row]
        let index = workers[shiftid]?.index(of: user)
        workers[shiftid]?.remove(at: index!)
        day.remove(worker: user, fromShift: shiftid, position: positionid)
    }
}
