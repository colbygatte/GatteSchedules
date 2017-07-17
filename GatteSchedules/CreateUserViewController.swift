//
//  CreateUserViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {
    var fontSize: CGFloat = 16.0
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var createUserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gsSetupNavBar()
    }

    @IBAction func createUserButtonPressed() {
        createUserButton.isEnabled = false

        let email = emailTextField.text! // @@@@ validate data
        let name = nameTextField.text!
        let teamid = App.teamSettings.teamid // @@@@ why does this have to be unwrapped below?

        let code = DB.createPendingUser(name: name, email: email, teamid: teamid!)

        codeLabel.text = "Code for \(name): \(code)"

        // _ = navigationController?.popViewController(animated: true)
    }
}

