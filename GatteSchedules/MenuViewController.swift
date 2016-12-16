//
//  MenuTableViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/8/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

struct MenuCellData {
    var text: String
    var block: ()->()
}

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let menuCellNib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(menuCellNib, forCellReuseIdentifier: "MenuCell")
        
        tableView.backgroundColor = App.Theme.menuBackgroundColor
        tableView.separatorColor = App.Theme.menuSeparatorColor
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // hides separator lines
        
        view.backgroundColor  = App.Theme.menuBackgroundColor
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.menuCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        let menuCellData = App.menuCells[indexPath.row]
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.text = menuCellData.text
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        App.menuCells[indexPath.row].block()
        App.toggleMenu()
    }
}
