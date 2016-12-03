//
//  FirstTimeLoginViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/3/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

// remember: auth listener is not running while we are in here (because it is accessed only
// from the login view controller

import UIKit

protocol FirstTimeLoginDelegate {
    func firstTimeLoginSuccess(user: GSUser)
}

class FirstTimeLoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    var pendingUser: GSPendingUser?
    var delegate: FirstTimeLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // step 1: get pending user, check if email matches
    @IBAction func loginButtonPressed() {
        let code = codeTextField.text!
        let email = emailTextField.text!
        
        DB.getPendingUser(code: code) { pendingUserSnap in
            self.pendingUser = GSPendingUser(snapshot: pendingUserSnap)
            
            if self.pendingUser!.email == email {
                self.getPassword()
            }
        }
    }
    
    // step 2: get user password & validate matching to retentered password
    func getPassword() {
        let alert = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        
        let done = UIAlertAction(title: "Done", style: .default, handler: { alertAction in
            let pw1 = alert.textFields![0].text!
            let pw2 = alert.textFields![1].text!
            
            if pw1 == pw2 {
                self.gotPassword(pw1)
            } else {
                alert.message = "Passwords do not match."
            }
        })
        alert.addAction(done)
        
        present(alert, animated: true)
    }
    
    // step 3: create the user with the email & password
    func gotPassword(_ password: String) {
        createNewUser(from: self.pendingUser!, password: password)
    }
    
    // step 4: create the new user
    // this will automatically log in the user (firebase always does this when creating a user)
    func createNewUser(from pendingUser: GSPendingUser, password: String) { // probably don't need to pass pendingUser, it's in self
        
        DB.createUser(email: pendingUser.email, password: password) { firUser, error in
            // all these optionals and unwrapping, do better here:
            let gsUser = GSUser(uid: (firUser?.uid)!, email: (self.pendingUser?.email)!, name: (self.pendingUser?.name)!, teamid: (self.pendingUser?.teamid)!, permissions: "normal", positions: [])
            DB.save(user: gsUser)
            
            DB.deletePendingUser(code: (self.pendingUser?.code)!)
            
            self.delegate?.firstTimeLoginSuccess(user: gsUser)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
