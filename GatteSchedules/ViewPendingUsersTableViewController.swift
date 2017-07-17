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
    var pendingUsers: [GSPendingUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadPendingUsers), for: .valueChanged)
        tableView.registerGSSubtitleTableViewCell()
        tableView.rowHeight = 55.0

        pendingUsers = []
        loadPendingUsers()
    }

    func loadPendingUsers() {
        DB.getPendingUsers { pendingUsersSnap in
            for pendingUserData in pendingUsersSnap.children {
                let pendingUserSnap = pendingUserData as! FIRDataSnapshot
                let pendingUser = GSPendingUser(snapshot: pendingUserSnap)
                self.pendingUsers.append(pendingUser)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return pendingUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pendingUser = pendingUsers[indexPath.row]

        let cell = tableView.dequeueGSSubtitleTableViewCell()
        cell.gsLabel.text = pendingUser.name
        cell.gsSubLabel.text = pendingUser.code

        return cell
    }
}
