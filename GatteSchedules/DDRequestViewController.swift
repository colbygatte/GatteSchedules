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
    var day: GSDay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDayOffCheckbox.delegate = self
        
    }
}

extension DDRequestViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        print("Tapped")
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        
    }
}
