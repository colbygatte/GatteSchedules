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
    var showEditCell = false
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.registerGSTableViewCell()
        
        title = App.scheduleDisplayFormatter.string(from: userDay.date)
        
        if App.loggedInUser.permissions == App.Permissions.manager {
            showEditCell = true
        }
        
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
        positionNames = App.teamSettings.positions
        positionids = Array(positionNames.keys)
        
        DB.get(day: userDay.date) { snap in
            self.day = GSDay(snapshot: snap)
            self.tableView.reloadData()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "DDRequest" {
            if day != nil {
                return true
            }
            return false
        } else if identifier == "DDWorkers" {
            let indexPath = (tableView.indexPathForSelectedRow)!
            if indexPath.row == 0 && showEditCell {
                let sb = UIStoryboard(name: "DayEditor", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DEIndex") as! DEIndexTableViewController
                if day != nil {
                    vc.day = day!
                    vc.dayChangedDelegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
                return false
            }
            return true
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DDWorkers" {
            let indexPath = (tableView.indexPathForSelectedRow)!
            
            var row: Int
            if showEditCell {
                row = indexPath.row - 1
            } else {
                row = indexPath.row
            }
            let positionid = positionids[row]
            
            let vc = segue.destination as! DDScheduleForPositionViewController
            vc.positionid = positionid
            vc.userDay = userDay
            
        } else if segue.identifier == "DDRequest" {
            let vc = segue.destination as! DDRequestViewController
            vc.day  = day!
        }
    }
}

// MARK: Table View

extension DDIndexViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userDay.published == false && App.loggedInUser.permissions != App.Permissions.manager {
            return 0
        }
        
        if showEditCell {
            return positionids.count + 1
        }
        return positionids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueGSTableViewCell()
        var row: Int
        if showEditCell {
            row = indexPath.row - 1
        } else {
            row = indexPath.row
        }
        
        if indexPath.row == 0 && showEditCell {
            cell.gsLabel.text = "Edit day"
            cell.gsLabel.font = App.globalFontThick
            cell.selectionStyle = .none
        } else {
            let positionName = positionNames[positionids[row]]
            cell.gsLabel.text = positionName
        }
        return cell
    }
}

extension DDIndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldPerformSegue(withIdentifier: "DDWorkers", sender: nil) {
            performSegue(withIdentifier: "DDWorkers", sender: nil)
        }
    }
}

extension DDIndexViewController: DayChangedDelegate {
    func dayChanged(newDay: GSDay) {
        day = newDay
    }
}
