//
//  SVIndexTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/6/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SVIndexTableViewController: UITableViewController {
    var now: Date!
    var dayStart: Int = 0
    var dayOffset: Int = -5
    var totalRows = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        now = Date()
        
        refreshControl?.addTarget(self, action: #selector(SVIndexTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        dayStart += dayOffset
        totalRows += 5
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeInterval = 60 * 60 * 24 * (indexPath.row + dayStart)
        let date = now.addingTimeInterval(TimeInterval(timeInterval))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = App.formatter.string(from: date)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let row = (tableView.indexPathForSelectedRow?.row)! + dayStart
        
        if segue.identifier == "SVDaySegue" {
            let svDayTableViewController = segue.destination as! SVDayTableViewController
            svDayTableViewController.date = now.addingTimeInterval(TimeInterval((60 * 60 * 24 * row)))
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == totalRows {
            totalRows += 5
            tableView.reloadData()
        }
    }
}
