//
//  ViewShiftTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class ViewShiftTableViewController: UITableViewController {
    
    var shiftData: [String: String]!
    var workers: [GSWorker]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = shiftData["shiftid"]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let uid = workers[indexPath.row].uid!
        let user = App.teamUsers[uid]!
        
        cell.textLabel?.text = user.name
        
        return cell
    }
}
