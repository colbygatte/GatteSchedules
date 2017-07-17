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
    
    var block: () -> ()
}

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        label.textColor = App.Theme.menuTextColor
        
        view.backgroundColor = App.Theme.menuBackgroundColor
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        tableView.backgroundColor = App.Theme.menuBackgroundColor
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // hides separator lines
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return App.menuCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCellData = App.menuCells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        cell.customLabel.text = menuCellData.text
        cell.customLabel.font = App.globalFontThick
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        App.menuCells[indexPath.row].block()
        App.toggleMenu()
    }
}
