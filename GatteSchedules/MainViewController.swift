//
//  IndexViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/29/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!

    var now: Date!
    var dateStart: Int = 0
    var totalSections: Int = 20
    var days: [GSUserDay]!
    var isDoneLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        now = Date()
        
        DB.setAuthListener { auth, user in
            if user != nil {
                DB.getUserData(uid: (user!.uid)) { userDataSnap in
                    let gsuser = GSUser(snapshot: userDataSnap, uid: (user?.uid)!)
                    App.loggedInUser = gsuser
                    DB.teamid = gsuser.teamid
                    DB.teamRef = DB.ref.child("teams").child(DB.teamid)
                    DB.daysRef = DB.teamRef.child("days")
                    
                    // this is called multiple times, we dont' want the app to begin multiple times
                    if App.loggedIn == false {
                        App.loggedIn = true
                        self.begin()
                    }
                }
            } else {
                App.loggedIn = false
                
                let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
        DB.startAuthListener()
    }
    
    func begin() {
        DB.getSettings { settingsSnap in
            let settings = GSSettings(snapshot: settingsSnap)
            App.teamSettings = settings
        }
        
        DB.getUsers { usersSnap in
            App.team = GSTeam()
            
            for userData in usersSnap.children {
                let userSnap = userData as! FIRDataSnapshot
                let user: GSUser!
                if userSnap.key == App.loggedInUser.uid {
                    user = App.loggedInUser
                } else {
                    user = GSUser(snapshot: userSnap, uid: userSnap.key)
                }
                App.team.add(user: user)
            }
        }
        
        tableView.refreshControl?.addTarget(self, action: #selector(MainViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        let cellNib = UINib(nibName: "USVScheduleTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "USVScheduleTableViewCell")
        let loadMoreNib = UINib(nibName: "LoadMoreTableViewCell", bundle: nil)
        tableView.register(loadMoreNib, forCellReuseIdentifier: "LoadMoreCell")
        
        welcomeLabel.text = "Welcome, \((App.loggedInUser.name)!)"
        makeMenu()
        data()
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
    
    func makeMenu() {
        App.clearMenu()
        let mb1 = MenuCellData(text: "Settings", block: {
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "Settings")
            self.navigationController?.pushViewController(vc, animated: true)
        })
        App.menuCells.append(mb1)
    
        let logoutMenuButton = MenuCellData(text: "Logout", block: {
            DB.signOut {
                App.loggedIn = false
            }
        })
        App.menuCells.append(logoutMenuButton)
        
        let scheduleAdminButton = MenuCellData(text: "Schedule admin", block: {
            let sb = UIStoryboard(name: "ScheduleViewer", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SVIndex")
            self.navigationController?.pushViewController(vc, animated: true)
        })
        App.menuCells.append(scheduleAdminButton)
        
        App.refreshMenu()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        dateStart += -5
        totalSections += 5
        data()
        refreshControl.endRefreshing()
    }
    
    @IBAction func menuButtonPressed() {
        App.toggleMenu()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if App.loggedIn == true {
            return totalSections + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == totalSections {
            return nil
        }
        
        let day = days[section]
        return App.formatter.string(from: day.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isDoneLoading {
            if cell.reuseIdentifier == "LoadMoreCell" {
                totalSections += 5
                data()
            }
        }
    }
}
