//
//  USVScheduleTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class USVScheduleTableViewController: UITableViewController {
    var now: Date!
    var dateStart: Int = 0
    var totalSections: Int = 20
    var days: [GSUserDay]!
    var isDoneLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        now = Date()
        days = []
        
        data()
        
        refreshControl?.addTarget(self, action: #selector(USVScheduleTableViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        
        let cellNib = UINib(nibName: "USVScheduleTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "USVScheduleTableViewCell")
        let loadMoreNib = UINib(nibName: "LoadMoreTableViewCell", bundle: nil)
        tableView.register(loadMoreNib, forCellReuseIdentifier: "LoadMoreCell")
        
    }
    
    func data() {
        days = []
        isDoneLoading = false
        
        for i in dateStart...dateStart + totalSections {
            let date = App.getDateFromNow(i)
            let day = GSUserDay(date: date, user: App.loggedInUser)
            
            days.append(day)
            
            DB.get(day: day.date) { snap in
                let gsDay = GSDay(snapshot: snap)
                day.addData(day: gsDay)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    if i == self.dateStart + self.totalSections {
                        self.isDoneLoading = true
                    }
                }
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        dateStart += -5
        totalSections += 5
        data()
        refreshControl.endRefreshing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == totalSections {
            return nil
        }
        
        let day = days[section]
        return App.formatter.string(from: day.date)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == totalSections {
            return 1
        }
        let shiftNumber = days[section].shifts.count
        
        if shiftNumber == 0 {
            return 1
        } else {
            return days[section].shifts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == totalSections {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath)
            cell.textLabel?.text = "Load More"
            return cell
        } else {
            let day = days[indexPath.section]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "USVScheduleTableViewCell", for: indexPath) as! USVScheduleTableViewCell
            
            if !day.published {
                cell.setIsNotPublished()
            } else if day.isOff {
                cell.setIsOff()
            } else {
                cell.set(day: day, shift: day.shifts[indexPath.row])
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isDoneLoading {
            if cell.reuseIdentifier == "LoadMoreCell" {
                totalSections += 5
                data()
            }
        }
    }
}
