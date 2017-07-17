//
//  ShiftsTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class ShiftsTableViewController: UITableViewController {

    var shiftids: [String]!
    var addedShiftid: String?

    override func viewWillAppear(_: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        tableView.registerGSTableViewCell()
        begin(again: false)
    }

    func begin(again: Bool) {
        shiftids = Array(App.teamSettings.shifts.keys)
        if again {
            tableView.reloadData()
        }
    }

    @IBAction func addShiftButtonPressed() {
        let alert = UIAlertController(title: "Add Shift", message: nil, preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            let shiftName = alert.textFields?[0].text
            let shiftid = DB.teamRef.child("settings/shifts").childByAutoId().key

            App.teamSettings.addShift(name: shiftName!, id: shiftid)
            self.addedShiftid = shiftid
            DB.save(settings: App.teamSettings)
            self.begin(again: true)

            self.performSegue(withIdentifier: "EditShift", sender: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()
        alert.textFields?[0].placeholder = "Shift name"
        alert.addAction(add)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "EditShift" {
            let shiftid = (nil != addedShiftid) ? addedShiftid! : shiftids[(tableView.indexPathForSelectedRow?.row)!]

            let editShiftViewController = segue.destination as! EditShiftViewController
            
            editShiftViewController.shiftid = shiftid
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return shiftids.count
    }

    override func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        performSegue(withIdentifier: "EditShift", sender: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftName = App.teamSettings.shiftNames[shiftids[indexPath.row]]

        let cell = tableView.dequeueGSTableViewCell()
        cell.gsLabel.text = shiftName

        return cell
    }
}
