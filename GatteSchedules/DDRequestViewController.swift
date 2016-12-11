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
    var day: GSDay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDayOffCheckbox.delegate = self
        requestDayOffCheckbox.onAnimationType = .fill
        requestDayOffCheckbox.offAnimationType = .fill
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func submitButtonPressed() {
        
    }
}

extension DDRequestViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        print("Tapped")
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        
    }
}

extension DDRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hi"
        return cell
    }
}

extension DDRequestViewController: UITableViewDelegate {
    
}
