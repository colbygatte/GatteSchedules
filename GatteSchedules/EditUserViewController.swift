//
//  AddUserViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

// Section 0 of table view: positions
// Section 1 of table view: shifts
class EditUserViewController: UIViewController {
    var positionids: [String]!
    
    var shiftids: [String]!
    
    var user: GSUser!

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gsSetupNavBar()
        
        setupTableView()
        
        positionids = App.teamSettings.getPositionIds()
        
        shiftids = App.teamSettings.getShiftIds()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EditUserTableViewCell", bundle: nil), forCellReuseIdentifier: "EditUserCell")
    }

    @IBAction func saveButtonPressed() {
        var positions: [String] = []
        var shifts: [String] = []
        
        for path in tableView.indexPathsForVisibleRows ?? [] {
            if path.section == 0 {
                positions.append(positionids[path.row])
            } else if path.section == 1 {
                shifts.append(shiftids[path.row])
            }
        }

        user.positions = positions
        user.shifts = shifts

        DB.save(user: user)
        
        _ = navigationController?.popViewController(animated: true)
    }
}

extension EditUserViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Workable positions"
        } else if section == 1 {
            return "Workable shifts"
        } else {
            return "Other"
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return positionids.count
        } else if section == 1 {
            return shiftids.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserCell", for: indexPath) as! EditUserTableViewCell
        cell.selectionStyle = .none

        if indexPath.section == 0 {
            let positionid = positionids[indexPath.row]
            if user.canDo(position: positionid) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            cell.customLabel.text = App.teamSettings.getPosition(id: positionid)
        } else if indexPath.section == 1 {
            let shiftid = shiftids[indexPath.row]
            if user.canDo(shift: shiftid) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            cell.customLabel.text = App.teamSettings.getShift(id: shiftid)
        } else {
            if user.permissions == App.Permissions.manager {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            cell.customLabel.text = "Grant administrative permissions"
        }
        
        cell.customLabel.sizeToFit()

        return cell
    }
}

extension EditUserViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            user.permissions = App.Permissions.manager
        }
    }

    func tableView(_: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            user.permissions = App.Permissions.normal
        }
    }
}
