//
//  DDRequestViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import BEMCheckBox

class DDRequestViewController: UIViewController {
    @IBOutlet weak var requestDayOffCheckbox: BEMCheckBox!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesText: UITextView!
    var day: GSDay!
    
    var dayRequests: GSDayRequests!
    var userDayRequest: GSUserDayRequest?
    var shiftids: [String]!
    var shiftNames: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        
        requestDayOffCheckbox.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DDRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "DDRequestTableViewCell")
        
        shiftNames = App.teamSettings.shiftNames
        shiftids = Array(shiftNames.keys)
        
        DB.get(requests: day.date) { snap in
            self.dayRequests = GSDayRequests(snapshot: snap)
            self.begin()
        }
    }
    
    func begin() {
        var request = dayRequests.getRequest(forUser: App.loggedInUser.uid)
        if request == nil {
            request = GSUserDayRequest()
            request!.uid = App.loggedInUser.uid
        }
        userDayRequest = request!
        dayRequests.addUserRequest(uid: App.loggedInUser.uid, request: userDayRequest!)
        
        if userDayRequest!.requestDayOff {
            requestDayOffCheckbox.on = true
            tableView.alpha = 0.0
        }
        
        tableView.reloadData()
    }
    
    @IBAction func submitButtonPressed() {
        userDayRequest?.requests = []
        
        for i in 0..<shiftids.count {
            let shiftid = shiftids[i]
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! DDRequestTableViewCell
            
            var requestData = GSUserRequestData(shiftid: shiftid, requesting: "")
            if cell.requesting == "off" {
                requestData.requesting = "off"
            } else if cell.requesting == "work" {
                requestData.requesting = "work"
            }
            
            if requestData.requesting != "" {
                userDayRequest?.requests.append(requestData)
            }
        }
        
        // @@@@ change to save an individual user day
        DB.save(dayRequests: dayRequests)
        
        _ = navigationController?.popViewController(animated: true)
    }
}

extension DDRequestViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.on {
            UIView.animate(withDuration: TimeInterval(0.3), animations: { 
                self.tableView.alpha = 0.0
                self.userDayRequest?.requestDayOff = true
            })
        } else {
            UIView.animate(withDuration: TimeInterval(0.3), animations: { 
                self.tableView.alpha = 1.0
                self.userDayRequest?.requestDayOff = false
            })
        }
    }
}

extension DDRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userDayRequest == nil {
            return 0
        }
        return shiftids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftid = shiftids[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDRequestTableViewCell", for: indexPath) as! DDRequestTableViewCell
        cell.selectionStyle = .none
        cell.shiftNameLabel.text = shiftNames[shiftid]
        
        let requesting = userDayRequest!.requestFor(shift: shiftid)
    
        if requesting != nil {
            cell.setRequest(to: requesting!)
        }
        
        return cell
    }
}

extension DDRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DDRequestTableViewCell
        cell.toggleRequest()
        
    }
}
