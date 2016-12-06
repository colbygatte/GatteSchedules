//
//  AddUserViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

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
        
        user.email = email
        user.name = username
        user.positions = positions
        
        DB.save(user: user)
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension EditUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let positionid = positionids[indexPath.row]
        if user.canDo(position: positionid) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        cell.textLabel?.text = App.teamSettings.getPosition(id: positionids[indexPath.row])
        
        return cell
    }
}
