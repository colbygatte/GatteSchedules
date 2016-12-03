//
//  ViewUsersTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class ViewUsersTableViewController: UITableViewController {

    var uids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uids = App.team.allUids
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = App.team.get(user: uids[indexPath.row])?.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let editUserViewController = segue.destination as! EditUserViewController
            editUserViewController.user = App.team.get(user: uids[row])
        } else if segue.identifier == "CreateUser" {
            let createUserViewController = segue.destination as! CreateUserViewController
        }
    }
}

