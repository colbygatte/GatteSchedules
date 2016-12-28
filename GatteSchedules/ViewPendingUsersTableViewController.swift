//
//  ViewPendingUsersTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/3/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewPendingUsersTableViewController: UITableViewController {
    var pendingUsers: [GSPendingUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pendingUsers = []
        loadPendingUsers()
    }
    
    func loadPendingUsers() {
        DB.getPendingUsers() { pendingUsersSnap in
            self.pendingUsers = []
            for pendingUserData in pendingUsersSnap.children {
                let pendingUserSnap = pendingUserData as! FIRDataSnapshot
                let pendingUser = GSPendingUser(snapshot: pendingUserSnap)
                self.pendingUsers.append(pendingUser)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pendingUser = pendingUsers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pendingUser.name
        cell.detailTextLabel?.text = pendingUser.code
        return cell
    }
}
