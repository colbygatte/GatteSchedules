//
//  SEPositionViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class DEPositionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var day: GSDay!
    
    var dayRequests: GSDayRequests!
    
    var positionid: String!

    var shiftNames: [String: String]!
    
    var shiftids: [String]!
    
    var workers: [String: [GSUser]] = [:] // shiftid: users
    
    var possibleWorkers: [GSUser] = [] // all workers who can work this shift

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gsSetupNavBar()
        
        setupTableView()
        
        begin()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DDPositionTableViewCell", bundle: nil), forCellReuseIdentifier: "DDPositionCell")
        tableView.rowHeight = 55.0
        tableView.alwaysBounceVertical = false
    }

    func begin() {
        possibleWorkers = App.team.getUsersWhoCanWork(position: positionid)
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)

        var sectionIndex = 0
        
        for shiftid in shiftids {
            let shift = day!.get(shift: shiftid)
            let thisPosition = shift.get(position: positionid)
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

    func verifyCanWorkShift(_ indexPath: IndexPath) {
        let user = possibleWorkers[indexPath.row]
        let shiftid = shiftids[indexPath.section]

        let message = user.name + " is not defined to work " + shiftNames[shiftid]! + ". Schedule anyway?"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.day.add(worker: user, toShift: shiftid, position: self.positionid)
            self.workers[shiftid]?.append(user)
        }
        
        let no = UIAlertAction(title: "No", style: .default) { _ in }
        
        alert.addAction(yes)
        alert.addAction(no)

        present(alert, animated: true, completion: nil)
    }
}

extension DEPositionViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return shiftids.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shiftNames[shiftids[section]]
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
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

        // Check to see if user can work shift
        if !user.canDo(shift: shiftid) {
            cell.nameLabel.textColor = UIColor.lightGray
            cell.canWorkShift = false
        }

        cell.nameLabel.text = user.name
        cell.nameLabel.sizeToFit()
        cell.subLabel.sizeToFit()

        return cell
    }
}

extension DEPositionViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shiftid = shiftids[indexPath.section]
        
        let user = possibleWorkers[indexPath.row]

        day.add(worker: user, toShift: shiftid, position: positionid)
        
        workers[shiftid]?.append(user)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! DDPositionTableViewCell
        
        if cell.canSelect {
            if !cell.canWorkShift {
                verifyCanWorkShift(indexPath)
                return nil
            }

            return indexPath
        }
        
        return nil
    }

    func tableView(_: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let shiftid = shiftids[indexPath.section]
        let user = possibleWorkers[indexPath.row]
        let index = workers[shiftid]?.index(of: user)
        workers[shiftid]?.remove(at: index!)
        day.remove(worker: user, fromShift: shiftid, position: positionid)
    }
}
