//
//  CreateUserViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createUserButtonPressed() {
        let email = emailTextField.text! // @@@@ validate data
        let name = nameTextField.text!
        let teamid = App.teamSettings.teamid // @@@@ why does this have to be unwrapped below?
        
        DB.createPendingUser(name: name, email: email, teamid: teamid!)
        
        _ = navigationController?.popViewController(animated: true)
    }
}
