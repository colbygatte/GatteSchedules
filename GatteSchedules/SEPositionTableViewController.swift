//
//  SEPositionTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEPositionTableViewController: UITableViewController {
    var day: GSDay!
    var shift: GSShift!
    var position: GSPosition!
    
    var workers: [String: GSUser]!
    var allUsers: [String: GSUser]!
    var allUids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workers = position.getWorkersDictionary()
        allUsers = [:]
        for user in App.team.getUsersWhoCanWork(position: position.positionid) {
            allUsers[user.uid] = user
        }
        allUids = Array(allUsers.keys)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let userUid = allUids[row]
        let workerName = allUsers[userUid]?.name
        
        if workers[userUid] != nil {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = workerName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let uid = allUids[row]
        let user = allUsers[uid]
        position.add(worker: user!)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let uid = allUids[row]
        let user = allUsers[uid]
        position.remove(worker: user!)
    }
}
