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

    var uids: [String] = []
    
    var team: GSTeam!

    override func viewWillAppear(_: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gsSetupNavBar()

        loadUsers()
    }
    
    func setupTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadUsers), for: .valueChanged)
        tableView.registerGSTableViewCell()
    }

    func loadUsers() {
        DB.getUsers { snap in
            self.team = GSTeam()
            
            for userData in snap.children {
                let userSnap = userData as! FIRDataSnapshot
                let user = GSUser(snapshot: userSnap, uid: userSnap.key)
                self.team.add(user: user)
            }

            self.uids = self.team.allUids
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return uids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueGSTableViewCell()
        
        cell.gsLabel.text = team.get(user: uids[indexPath.row])?.name

        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        performSegue(withIdentifier: __("EditUser"), sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == __("EditUser") {
            let row = (tableView.indexPathForSelectedRow?.row)!

            let editUserViewController = segue.destination as! EditUserViewController
            
            editUserViewController.user = team.get(user: uids[row])
        }
    }
}
