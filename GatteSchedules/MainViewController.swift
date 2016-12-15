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
    var userDays: [GSUserDay]!
    var isDoneLoading: Bool = false
    var nextWorkingDay: GSUserDay?
    
    
    override func viewWillAppear(_ animated: Bool) {
        //DB.signOut()
        
        App.containerViewController.setSwipeLeftGesture(on: true)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let section = selectedIndexPath.section
            loadUserDay(index: section)
            tableView.deselectRow(at: selectedIndexPath, animated: true)
            
        }
        
        tableView.rowHeight = 55.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        App.containerViewController.setSwipeLeftGesture(on: false)
    }
    
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
                    DB.requestsRef = DB.teamRef.child("requests")
                    
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
            App.team = GSTeam()
            
            DB.getUsers { usersSnap in
                for userData in usersSnap.children {
                    let userSnap = userData as! FIRDataSnapshot
                    let user: GSUser!
                    if userSnap.key == App.loggedInUser.uid {
                        user = App.loggedInUser
                    } else {
                        user = GSUser(snapshot: userSnap, uid: userSnap.key)
                    }
                    App.team.add(user: user)
                    
                    // Moved load user days in here because
                    // we are comparing users to the App.team users, and above
                    // we set the logged in user's GSUser to it's respective place in
                    // App.team
                    self.loadUserDays()
                }
            }
        }
        
        tableView.refreshControl?.addTarget(self, action: #selector(MainViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        let cellNib = UINib(nibName: "USVScheduleTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "USVScheduleTableViewCell")
        let loadMoreNib = UINib(nibName: "LoadMoreTableViewCell", bundle: nil)
        tableView.register(loadMoreNib, forCellReuseIdentifier: "LoadMoreCell")
        
        makeMenu()
    }
    
    func loadUserDays() {
        userDays = []
        isDoneLoading = false
        
        for i in dateStart...dateStart + totalSections {
            let date = App.getDateFromNow(i)
            let day = GSUserDay(date: date, user: App.loggedInUser)
            userDays.append(day)
            
            DB.get(day: day.date) { snap in
                let gsDay = GSDay(snapshot: snap)
                day.addData(day: gsDay)
                
                DispatchQueue.main.async {
                    if i == self.dateStart + self.totalSections {
                        self.tableView.reloadData()
                        self.isDoneLoading = true
                    }
                }
            }
        }
    }
    
    func loadUserDay(index: Int) {
        let day = userDays[index]
        DB.get(day: day.date) { snap in
            let gsDay = GSDay(snapshot: snap)
            day.addData(day: gsDay)
            
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    func makeMenu() {
        App.clearMenu()
        
        if App.loggedInUser.permissions == App.Permissions.manager {
            let userMb = MenuCellData(text: "Users", block: {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ViewUsers")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            App.menuCells.append(userMb)
            
            let pendingUsersMb = MenuCellData(text: "Pending users", block: {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ViewPendingUsers")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            App.menuCells.append(pendingUsersMb)
            
            let mb1 = MenuCellData(text: "Settings", block: {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Settings")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            App.menuCells.append(mb1)
        }
        
        let logoutMenuButton = MenuCellData(text: "Logout", block: {
            DB.signOut {
                App.loggedIn = false
            }
        })
        App.menuCells.append(logoutMenuButton)
        App.refreshMenu()
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
        if section == totalSections {
            return nil
        }
        
        let day = userDays[section]
        return App.scheduleDisplayFormatter.string(from: day.date)
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
            cell.setIsNotPublished()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let userDay = userDays[section]
        
        let sb = UIStoryboard(name: "DayDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DDIndex") as! DDIndexViewController
        vc.userDay = userDay
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isDoneLoading {
            if indexPath.section + 1 == tableView.numberOfSections {
                totalSections += 5
                loadUserDays()
            }
        }
    }
}

