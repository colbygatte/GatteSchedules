//
//  SVPositionTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVPositionTableViewController: UITableViewController {
    var day: GSDay!
    var shift: GSShift!
    var position: GSPosition!
    
    var workers: [String: GSUser]!
    var uids: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workers = position.getWorkersDictionary()
        uids = Array(workers.keys)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let uid = uids[row]
        let worker = workers[uid]!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = worker.name
        return cell
    }
}
