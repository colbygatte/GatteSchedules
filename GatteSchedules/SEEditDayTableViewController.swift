//
//  SEEditDayTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEEditDayTableViewController: UITableViewController {
    var schedule: GSSchedule!
    var dayIndex: Int!
    var shiftNames: [String: String]!
    var shiftids: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shiftNames[shiftids[indexPath.row]]
        return cell
    }
}
