//
//  LoginViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        DB.signIn(username: username, password: password) { user, error in
            if error == nil {
                DB.getUserData(uid: (user!.uid)) { userDataSnapshot in
                    let user = GSUser(snapshot: userDataSnapshot, uid: user!.uid)
                    App.loggedInUser = user
                    App.loggedIn = true
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    @IBAction func createTeamButtonPressed(_ sender: Any) {
    }
}
