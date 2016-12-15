//
//  SEIndexTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import BEMCheckBox

// DayChangedDelegate is needed because the day editor changes the GSDay instance
// If the user cancels the changes, we need to assign a copy of the GSDay instance back to the DDIndexViewController's GSDay
protocol DayChangedDelegate {
    func dayChanged(newDay: GSDay)
}

class SEIndexTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var publishedCheckbox: BEMCheckBox!
    var day: GSDay!
    var dayCopy: GSDay!
    var dayChangedDelegate: DayChangedDelegate?
    
    var dayRequests: GSDayRequests?
    var positionNames: [String: String]!
    var positionids: [String]!
    var changesMade = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App.mustBeManager(self)
        dayCopy = day.copy() as! GSDay
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.setHidesBackButton(true, animated: false)
        
        publishedCheckbox.onAnimationType = .fill
        publishedCheckbox.offAnimationType = .fill
        
        tableView.dataSource = self
        tableView.delegate = self
        
        positionNames = App.teamSettings.positions
        positionids = Array(positionNames.keys)
        
        if day.published == true {
            publishedCheckbox.on = true
        } else {
            publishedCheckbox.on = false
        }
        
        DB.get(requests: day.date) { snap in
            self.dayRequests = GSDayRequests(snapshot: snap)
        }
    }
    
    @IBAction func saveButtonPressed() {
        if publishedCheckbox.on {
            day.published = true
        } else {
            day.published = false
        }
        DB.save(day: day)
        changesMade = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to exit? All unsaved changes will be lost.", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .cancel, handler: { alert in
            self.dayChangedDelegate?.dayChanged(newDay: self.dayCopy)
            _ = self.navigationController?.popViewController(animated: true)
        })
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SEPosition" {
            changesMade = true
            
            let row = (tableView.indexPathForSelectedRow?.row)!
            let positionid = positionids[row]
            
            let vc = segue.destination as! SEPositionViewController
            vc.day = day
            vc.positionid = positionid
            if dayRequests != nil {
                vc.dayRequests = dayRequests!
            }
        }
    }
}

extension SEIndexTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let positionName = positionNames[positionids[row]]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = positionName
        return cell
    }
}


