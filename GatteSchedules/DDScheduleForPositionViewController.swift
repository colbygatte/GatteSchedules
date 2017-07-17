//
//  DDScheduleForPositionViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class DDScheduleForPositionViewController: UIViewController {
    var userDay: GSUserDay!
    
    var positionid: String!

    var day: GSDay?
    
    var shiftNames: [String: String]!
    
    var shiftids: [String]!
    
    var workers: [String: [GSUser]]! // shiftid: users

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()

        tableView.dataSource = self
        tableView.registerGSTableViewCell()

        title = App.teamSettings.getPosition(id: positionid)

        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
        workers = [:]

        DB.get(day: userDay.date) { snap in
            self.day = GSDay(snapshot: snap)
            
            for shiftid in self.shiftids {
                let shift = self.day!.get(shift: shiftid)
                let thisPosition = shift.get(position: self.positionid)
                let workers = thisPosition.workers

                self.workers[shiftid] = workers
            }
            
            self.tableView.reloadData()
        }
    }
}

extension DDScheduleForPositionViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return shiftids.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shiftNames[shiftids[section]]
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let shiftid = shiftids[section]
        
        return nil != day ? 0 : (workers[shiftid]?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftid = shiftids[indexPath.section]

        let cell = tableView.dequeueGSTableViewCell()
        
        cell.selectionStyle = .none
        cell.gsLabel.text = workers[shiftid]?[indexPath.row].name
        
        return cell
    }
}
