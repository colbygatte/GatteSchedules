//
//  PositionsTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class PositionsTableViewController: UITableViewController {
    
    var positionids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        begin(again: false)
    }
    
    func begin(again: Bool) {
        positionids = Array(App.teamSettings.positions.keys)
        if again {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let positionid = positionids[indexPath.row]
        let position = App.teamSettings.positions[positionid]
        
        cell.textLabel?.text = position
        
        return cell
    }
    
    @IBAction func addPositionButtonPressed() {
        let alert = UIAlertController(title: "Add Position", message: nil, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { action in
            let positionName = alert.textFields![0].text!
            let positionid = alert.textFields![1].text!
            
            App.teamSettings.addPosition(name: positionName, id: positionid)
            DB.save(settings: App.teamSettings)
            self.begin(again: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addTextField()
        alert.textFields?[0].placeholder = "Position title"
        alert.textFields?[1].placeholder = "Position ID"
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
