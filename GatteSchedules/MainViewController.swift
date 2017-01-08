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
    @IBOutlet weak var menuButton: UIBarButtonItem!

    var now: Date!
    var dateStart: Int = 0
    var totalSections: Int = 20
    var userDays: [GSUserDay]!
    var fullDays: [GSDay]!
    var isDoneLoading: Bool = false
    var nextWorkingDay: GSUserDay?
    var cannotRequestBefore: Date!
    
    override func viewWillAppear(_ animated: Bool) {
        App.containerViewController.setSwipeLeftGesture(on: true)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        App.containerViewController.setSwipeLeftGesture(on: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
        
        let menuButtonImage = UIImage(named: "CellGripper.png")
        let button = UIButton()
        button.setImage(menuButtonImage, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(MainViewController.menuButtonPressed), for: .touchUpInside)
        menuButton.customView = button
        
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.sectionHeaderHeight = 25.0
        
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
        tableView.register(UINib(nibName: "USVScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "USVScheduleTableViewCell")
        
        now = Date()
        
        // Auth listener is used to get the logged in user and update the APN token if it changes.
        // Will present the login view controller if not logged in.
        DB.setAuthListener { auth, user in
            if user != nil {
                DB.getUserData(uid: (user!.uid)) { userDataSnap in
                    let gsuser = GSUser(snapshot: userDataSnap, uid: (user?.uid)!)
                    
                    App.welcomeMessage = "Hello, \(gsuser.name!)!"
                    
                    App.loggedInUser = gsuser
                    App.setRefs(withTeamId: gsuser.teamid)
                    
                    // this is called multiple times, we dont' want the app to begin multiple times
                    if App.loggedIn == false {
                        if App.apnToken != nil && !App.loggedInUser.apnTokens.contains(App.apnToken!) {
                            App.loggedInUser.apnTokens.append(App.apnToken!)
                            DB.save(user: App.loggedInUser)
                            DB.saveTokens(user: App.loggedInUser)
                        }
                        
                        App.loggedIn = true
                        self.begin()
                    }
                }
            } else {
                App.loggedIn = false
                
                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login")
                self.present(vc, animated: true, completion: nil)
            }
        }
        DB.startAuthListener()
    }
    
    func begin() {
        DB.getSettings { settingsSnap in
            let settings = GSSettings(snapshot: settingsSnap)
            App.teamSettings = settings
            self.cannotRequestBefore = App.getDateFromNow(App.teamSettings.daysPriorRestriction)
            
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
            
            // Moved load user days in here because
            // we are comparing users to the App.team users, and above
            // we set the logged in user's GSUser to it's respective place in
            // App.team
            self.loadUserDays()
        }
        
        App.makeMenu()
    }
    
    func loadUserDays() {
        DB.teamRef.child("lastChanged").observe(.value, with: { snap in
            self.userDays = []
            self.fullDays = []
            self.isDoneLoading = false
            
            print("@1")
            for i in self.dateStart...self.dateStart + self.totalSections {
                print("@2")
                let date = App.getDateFrom(self.now, days: i)
                let day = GSUserDay(date: date, user: App.loggedInUser)
                self.userDays.append(day)
                
                DB.get(day: day.date) { snap in
                    print("@3")
                    let gsDay = GSDay(snapshot: snap)
                    self.fullDays.append(gsDay)
                    day.addData(day: gsDay)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if i == self.dateStart + self.totalSections {
                            self.isDoneLoading = true
                        }
                    }
                }
            }
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        dateStart += -5
        totalSections += 5
        loadUserDays()
        refreshControl.endRefreshing()
    }
    
    @IBAction func menuButtonPressed() {
        App.toggleMenu()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Jump" {
            let vc = segue.destination as! JumpViewController
            vc.date = now
            vc.delegate = self
        }
    }
}

// MARK: Table View Data Source

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if App.loggedIn == true {
            return totalSections
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = userDays[section]
        
        if App.formatter.string(from: day.date) == App.formatter.string(from: App.now) {
            return App.scheduleDisplayFormatter.string(from: day.date) + " - Today"
        } else {
            return App.scheduleDisplayFormatter.string(from: day.date)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let shiftNumber = userDays[section].shifts.count
        
        if shiftNumber == 0 || !userDays[section].published { // if there are no shifts or the day is unpublished
            return 1
        } else {
            return userDays[section].shifts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = userDays[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "USVScheduleTableViewCell", for: indexPath) as! USVScheduleTableViewCell
        
        if !day.published {
            if day.date < cannotRequestBefore {
                cell.setIsNotPublishedAndCannotRequest()
            } else {
                cell.setIsNotPublishedAndCanRequest()
            }
        } else if day.isOff {
            cell.setIsOff()
        } else {
            cell.set(day: day, shift: day.shifts[indexPath.row])
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: Table View Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let day = userDays[section]
        let text: String
        if App.formatter.string(from: day.date) == App.formatter.string(from: App.now) {
            text = App.scheduleDisplayFormatter.string(from: day.date) + " - Today"
        } else {
            text = App.scheduleDisplayFormatter.string(from: day.date)
        }
        
        let headerView = MainSectionHeaderView()
        headerView.sectionTitleLabel.text = text
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25)
        headerView.setFrame()
        headerView.clipsToBounds = true
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let cell = tableView.cellForRow(at: indexPath) as! USVScheduleTableViewCell
        let userDay = userDays[section]
        
        if userDay.published == true {
            let sb = UIStoryboard(name: "DayDetail", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DDIndex") as! DDIndexViewController
            vc.userDay = userDay
            navigationController?.pushViewController(vc, animated: true)
        } else if App.loggedInUser.permissions == App.Permissions.manager {
            let sb = UIStoryboard(name: "DayEditor", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DEIndex") as! DEIndexTableViewController
            vc.day = fullDays[section]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if !cell.unpublishedAndCannotRequest {
                let sb = UIStoryboard(name: "DayDetail", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DDRequest") as! DDRequestViewController
                vc.day = fullDays[section]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isDoneLoading {
            if indexPath.section + 1 == tableView.numberOfSections {
                totalSections += 15
                loadUserDays()
            }
        }
    }
}

extension MainViewController: JumpViewControllerDelegate {
    func jumperDateChosen(_ dateStart: Date) {
        now = dateStart
        loadUserDays()
    }
}

