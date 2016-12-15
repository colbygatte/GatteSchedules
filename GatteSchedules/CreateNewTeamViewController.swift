//
//  CreateNewTeamViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/15/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class CreateNewTeamViewController: UIViewController {
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pw1TextField: UITextField!
    @IBOutlet weak var pw2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var delegate: FirstTimeLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createTeamButtonPressed() {
        if let pw1 = pw1TextField.text, let pw2 = pw2TextField.text, let email = emailTextField.text, let teamName = teamNameTextField.text, let name = nameTextField.text {
            if pw1 == pw2 {
                DB.createUser(email: email, password: pw1, completion: { user, error in
                    if error == nil {
                        let teamid = DB.create(team: teamName)
                        let gsUser = GSUser(uid: user!.uid, email: email, name: name, teamid: teamid, permissions: App.Permissions.manager, positions: [], shifts: [])
                        DB.save(user: gsUser)
                        self.delegate?.firstTimeLoginSuccess(user: gsUser)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            }
        }
    }
}
