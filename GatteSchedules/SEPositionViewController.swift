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
    var dayRequests: GSDayRequests!
    var positionid: String!
    
    var shiftNames: [String: String]!
    var shiftids: [String]!
    var workers: [String: [GSUser]]! // shiftid: users
    var possibleWorkers: [GSUser]! // all workers who can work this shift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DDPositionTableViewCell", bundle: nil), forCellReuseIdentifier: "DDPositionCell")
        tableView.rowHeight = 55.0
        tableView.alwaysBounceVertical = false
        
        begin()
    }
    
    func begin() {
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
        let user = possibleWorkers[indexPath.row]
        let shiftid = shiftids[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDPositionCell", for: indexPath) as! DDPositionTableViewCell
        var texts: [String] = []
        
        if let userShiftData = day.isWorking(uid: user.uid, shift: shiftid) {
            if userShiftData.positionid != positionid {
                if let positionName = App.teamSettings.getPosition(id: userShiftData.positionid) {
                    texts.append("Working \(positionName)")
                } else {
                    texts.append("Working another position")
                }
                cell.canSelect = false
            }
        }
        
        if let userRequest = dayRequests.getRequest(forUser: user.uid) {
            let request = userRequest.requestFor(shift: shiftid)
            if request == "off" {
                texts.append("Wants off")
            } else if request == "work" {
                texts.append("Wants to work")
            }
        }
        
        cell.subLabel.text = texts.joined(separator: " - ")
        
        if !user.canDo(shift: shiftid) {
            cell.nameLabel.textColor = UIColor.lightGray
        }
        
        cell.nameLabel.text = user.name
        cell.nameLabel.sizeToFit()
        cell.subLabel.sizeToFit()
        
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! DDPositionTableViewCell
        if cell.canSelect {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let shiftid = shiftids[indexPath.section]
        let user = possibleWorkers[indexPath.row]
        let index = workers[shiftid]?.index(of: user)
        workers[shiftid]?.remove(at: index!)
        day.remove(worker: user, fromShift: shiftid, position: positionid)
    }
}
