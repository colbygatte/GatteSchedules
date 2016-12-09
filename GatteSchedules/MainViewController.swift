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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mb1 = MenuCellData(text: "Settings", block: {
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "Settings")
            self.navigationController?.pushViewController(vc, animated: true)
        })
        App.menuCells.append(mb1)
        
        App.refreshMenu()
        
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
//        
//        let tomorrowDate = App.getDateFromNow(1)
//        DB.get(day: tomorrowDate) { tomorrowSnap in
//            let tomorrow = GSDay(snapshot: tomorrowSnap)
//            let userTomorrow = GSUserDay(from: tomorrow, user: App.loggedInUser)
//            
//            
//        }
    }
    
    @IBAction func menuButtonPressed() {
        App.toggleMenu()
    }
    
    @IBAction func logoutButtonPressed() {
        DB.signOut {
            App.loggedIn = false
        }
    }
}

