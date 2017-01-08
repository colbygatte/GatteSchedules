//
//  JumpViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 1/7/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

protocol JumpViewControllerDelegate {
    func jumperDateChosen(_ date: Date)
}

class JumpViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: JumpViewControllerDelegate?
    var date: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = date
        
        gsSetupNavBar()
    }
    
    @IBAction func todayButtonPressed() {
        datePicker.date = Date()
    }
    
    @IBAction func choose() {
        delegate?.jumperDateChosen(datePicker.date)
        _ = navigationController?.popViewController(animated: true)
    }
}

