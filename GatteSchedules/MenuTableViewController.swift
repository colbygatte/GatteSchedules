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

class MenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuCellNib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(menuCellNib, forCellReuseIdentifier: "MenuCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.menuCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCellData = App.menuCells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.text = menuCellData.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        App.menuCells[indexPath.row].block()
        App.toggleMenu()
    }
}
