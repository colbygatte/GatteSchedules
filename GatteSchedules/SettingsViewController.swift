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
    @IBOutlet weak var tableView: UITableView!
    var cells: [SettingsCell]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        cells = [
            SettingsCell(storyboarId: "ShiftsView", text: "Edit shifts"),
            SettingsCell(storyboarId: "PositionsView", text: "Edit positions")
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        if selectedIndexPath != nil {
            tableView.deselectRow(at: selectedIndexPath!, animated: true)
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellData.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = cells[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: cellData.storyboarId)
        navigationController?.pushViewController(vc!, animated: true)
    }
}
