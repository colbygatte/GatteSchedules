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
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let add = UIAlertAction(title: "Add", style: .default) { action in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditShift" {
            let shiftid: String
            if addedShiftid == nil {
                shiftid = shiftids[(tableView.indexPathForSelectedRow?.row)!]
            } else {
                shiftid = addedShiftid!
            }
            
            let editShiftViewController = segue.destination as! EditShiftViewController
            editShiftViewController.shiftid = shiftid
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftids.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditShift", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftName = App.teamSettings.shiftNames[shiftids[indexPath.row]]
        
        let cell = tableView.dequeueGSTableViewCell()
        cell.gsLabel.text = shiftName
        
        return cell
    }
}
