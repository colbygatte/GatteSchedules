//
//  DDIndexViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/9/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class DDIndexViewController: UIViewController {
    var userDay: GSUserDay!
    
    var day: GSDay?

    var shiftNames: [String: String]!
    
    var shiftids: [String]!
    
    var positionNames: [String: String]!
    
    var positionids: [String]!
    
    var showEditCell = false
    
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gsSetupNavBar()
        
        setupTableView()
        
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

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.registerGSTableViewCell()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender _: Any?) -> Bool {
        if identifier == "DDRequest" {
            return nil != day
        } else if identifier == "DDWorkers" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return false
            }
            
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
        }
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let vc = segue.destination as? DDScheduleForPositionViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }

            let row = showEditCell ? (indexPath.row - 1) : indexPath.row
            
            let positionid = positionids[row]

            vc.positionid = positionid
            vc.userDay = userDay
        } else if let vc = segue.destination as? DDRequestViewController {
            vc.day = day!
        }
    }
}

// MARK: Table View

extension DDIndexViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if userDay.published == false && App.loggedInUser.permissions != App.Permissions.manager {
            return 0
        }

        return showEditCell ? (positionids.count + 1) : positionids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueGSTableViewCell()
        
        var row = showEditCell ? (indexPath.row - 1) : indexPath.row

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
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
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
