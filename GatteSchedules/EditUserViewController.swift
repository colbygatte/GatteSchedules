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
    
    var positionids: [String]!
    var user: GSUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        positionids = App.teamSettings.getPositionids()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func saveButtonPressed() {
        let indexPaths = tableView.indexPathsForSelectedRows
        
        var positions: [String] = []
        if indexPaths != nil {
            for path in indexPaths! {
                positions.append(positionids[path.row])
            }
        }
        
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
