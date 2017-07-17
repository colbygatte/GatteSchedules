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
        
        gsSetupNavBar()
        
        tableView.registerGSTableViewCell()

        begin(again: false)
    }

    func begin(again: Bool) {
        positionids = Array(App.teamSettings.positions.keys)
        
        if again {
            tableView.reloadData()
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return positionids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueGSTableViewCell()
        cell.selectionStyle = .none

        let positionid = positionids[indexPath.row]
        let position = App.teamSettings.positions[positionid]

        cell.gsLabel.text = position

        return cell
    }

    @IBAction func addPositionButtonPressed() {
        let alert = UIAlertController(title: "Add Position", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            let positionName = alert.textFields![0].text!
            let positionid = DB.teamRef.child("settings/positions").childByAutoId().key

            App.teamSettings.addPosition(name: positionName, id: positionid)
            DB.save(settings: App.teamSettings)
            self.begin(again: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()
        alert.textFields?[0].placeholder = "Position title"
        alert.addAction(save)
        alert.addAction(cancel)

        present(alert, animated: true)
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let positionid = positionids[indexPath.row]

        let alert = UIAlertController(title: "Update Position", message: nil, preferredStyle: .alert)
        
        let update = UIAlertAction(title: "Update", style: .default) { _ in
            let positionName = alert.textFields![0].text!

            App.teamSettings.addPosition(name: positionName, id: positionid)
            DB.save(settings: App.teamSettings)
            self.begin(again: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()
        alert.textFields?[0].placeholder = "Position title"
        alert.textFields?[0].text = App.teamSettings.positions[positionid]
        alert.addAction(update)
        alert.addAction(cancel)

        present(alert, animated: true)
    }

    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    override func tableView(_: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt _: IndexPath) {
        if editingStyle == .delete {

        }
    }
}
