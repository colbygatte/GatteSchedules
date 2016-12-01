//
//  AddUserViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class EditUserViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var positionids: [String]!
    var user: GSUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positionids = App.teamSettings.getPositionids()
        tableView.delegate = self
        tableView.dataSource = self
        
        emailTextField.text = user.email
        usernameTextField.text = user.name
        
        for userPosition in user.positions {
            let index = positionids.index(of: userPosition)
            let indexPath = IndexPath(row: index!, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
    }
    
    @IBAction func saveButtonPressed() {
        let indexPaths = tableView.indexPathsForSelectedRows
        
        let email = emailTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let permissions = "normal"
        
        var positions: [String] = []
        for path in indexPaths! {
            positions.append(positionids[path.row])
        }
        
        DB.addUser(email: email, password: password) { user, error in
            if error == nil {
                let user = GSUser(uid: user!.uid, email: email, name: username, teamid: App.teamSettings.teamid, permissions: permissions, positions: positions)
                
                DB.save(user: user)
                
                self.navigationController?.popViewController(animated: true)
            } else {
                assert(true)
            }
        }
    }
}

extension EditUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = App.teamSettings.getPosition(id: positionids[indexPath.row])
        
        return cell
    }
}
