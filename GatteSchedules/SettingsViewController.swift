//
//  SettingsViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

struct SettingsCell {
    var storyboarId: String
    var text: String
}

class SettingsViewController: UIViewController {
    var cells: [SettingsCell]!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerGSTableViewCell()

        title = "Settings"

        cells = [
            SettingsCell(storyboarId: "General", text: "General"),
            SettingsCell(storyboarId: "ShiftsView", text: "Shifts"),
            SettingsCell(storyboarId: "PositionsView", text: "Positions"),
        ]

    }

    override func viewWillAppear(_: Bool) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        if selectedIndexPath != nil {
            tableView.deselectRow(at: selectedIndexPath!, animated: true)
        }
    }
}

// MARK: Table View

extension SettingsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cells[indexPath.row]

        let cell = tableView.dequeueGSTableViewCell()
        cell.gsLabel.text = cellData.text
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = cells[indexPath.row]

        let vc = storyboard?.instantiateViewController(withIdentifier: cellData.storyboarId)
        navigationController?.pushViewController(vc!, animated: true)
    }
}
