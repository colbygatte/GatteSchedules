//
//  ViewUsersTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class ViewUsersTableViewController: UITableViewController {

    var uids: [String]!
    var team: GSTeam!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uids = []
        
        DB.getUsersValue { snap in
            self.team = GSTeam()
            for userData in snap.children {
                let userSnap = userData as! FIRDataSnapshot
                let user = GSUser(snapshot: userSnap, uid: userSnap.key)
                self.team.add(user: user)
            }
            
            self.uids = self.team.allUids
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = team.get(user: uids[indexPath.row])?.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let editUserViewController = segue.destination as! EditUserViewController
            editUserViewController.user = team.get(user: uids[row])
        } else if segue.identifier == "CreateUser" {
            let createUserViewController = segue.destination as! CreateUserViewController
        }
    }
}

