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

        DB.authListener { auth, user in
            if user != nil {
                DB.getUserData(uid: (user!.uid)) { userDataSnapshot in
                    let user = GSUser(snapshot: userDataSnapshot, uid: (user?.uid)!)
                    DB.loggedInUser = user
                    DB.teamid = user.teamid
                    DB.teamRef = FIRDatabase.database().reference().child("teams").child(DB.teamid)
                    
                    // this is called multiple times, we dont' want the app to begin multiple times
                    if DB.loggedIn == false {
                        DB.loggedIn = true
                        self.begin()
                    }
                }
            } else {
                DB.loggedIn = false
                
                let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
    }
    
    func begin() {
        DB.getSettings() { settingsSnap in
            let settings = GSSettings(snapshot: settingsSnap)
            App.teamSettings = settings
        }
        
        DB.getUsers() { usersSnap in
            App.teamUsers = [:]
            
            for userData in usersSnap.children {
                let userSnap = userData as! FIRDataSnapshot
                App.teamUsers[userSnap.key] = GSUser(snapshot: userSnap, uid: userSnap.key)
            }
        }
    }
    
    @IBAction func testClick() {
        begin()
    }
    
    @IBAction func logoutButtonPressed() {
        DB.signOut() {
            print("logg out b PRE")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            let settingsViewController = segue.destination as! SettingsViewController
            
        }
    }
}

/*
 TODO:
 Add progress circle thingy while loggin in and handle errors better
*/
