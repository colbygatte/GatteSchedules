//
//  LoginViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

// make sure anytime the login views are exited, the auth listener is started

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    var loggedInFromFirstTimeLogin: Bool = false
    
    // is this a good solution?
    override func viewWillAppear(_ animated: Bool) {
        if loggedInFromFirstTimeLogin {
            loggedInFromFirstTimeLogin = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DB.stopAuthListener() // stop in case it's the user's first login, because we need to make the user in user branch if it is there first login and the auth listener needs to get this data
        
        let logo = UIImage(named: "Logo.png")
        logoImageView.image = logo
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        DB.signIn(username: username, password: password) { user, error in
            if error == nil {
                DB.startAuthListener() // the auth listener starts the app (it calls MainViewController.begin())
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    @IBAction func createTeamButtonPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FirstTimeLogin" {
            let firstTimeLoginViewController = segue.destination as! FirstTimeLoginViewController
            firstTimeLoginViewController.delegate = self
        } else if segue.identifier == "CreateNewTeam" {
            let createnewTeamViewController = segue.destination as! CreateNewTeamViewController
            createnewTeamViewController.delegate = self
        }
    }
}

extension LoginViewController: FirstTimeLoginDelegate {
    func firstTimeLoginSuccess(user: GSUser) {
        DB.startAuthListener()
        loggedInFromFirstTimeLogin = true
    }
}
