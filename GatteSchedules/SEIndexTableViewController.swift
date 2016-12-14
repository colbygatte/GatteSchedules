//
//  SEIndexTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import BEMCheckBox

class SEIndexTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var publishedCheckbox: BEMCheckBox!
    var day: GSDay!
    
    var dayRequests: GSDayRequests?
    var positionNames: [String: String]!
    var positionids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App.mustBeManager(self)
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
        _ = navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SEPosition" {
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


