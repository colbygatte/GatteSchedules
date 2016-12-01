//
//  EditShiftViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class EditShiftViewController: UIViewController {
    @IBOutlet var beginDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    
    var shiftid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dates = App.teamSettings.getShiftDates(id: shiftid)
        beginDatePicker.date = dates.begin
        endDatePicker.date = dates.end
    }
    
    @IBAction func saveButtonPressed() {
        let dates = GSShiftDates(begin: beginDatePicker.date, end: endDatePicker.date)
        
        App.teamSettings.editShift(id: shiftid, dates: dates)
        
        DB.save(settings: App.teamSettings)
        
        navigationController?.popViewController(animated: true)
    }
}
