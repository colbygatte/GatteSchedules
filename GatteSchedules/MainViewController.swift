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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DB.setAuthListener { auth, user in
            if user != nil {
                DB.getUserData(uid: (user!.uid)) { userDataSnap in
                    let gsuser = GSUser(snapshot: userDataSnap, uid: (user?.uid)!)
                    App.loggedInUser = gsuser
                    DB.teamid = gsuser.teamid
                    DB.teamRef = DB.ref.child("teams").child(DB.teamid)
                    
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
                App.team.add(user: GSUser(snapshot: userSnap, uid: userSnap.key))
            }
        }
    }
    
    @IBAction func testClick() {
        begin()
    }
    
    @IBAction func logoutButtonPressed() {
        DB.signOut {
            print("logg out b PRE")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            _ = segue.destination as! SettingsViewController
            
        }
    }
}


