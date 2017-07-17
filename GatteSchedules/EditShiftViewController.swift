//
//  EditShiftViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class EditShiftViewController: UIViewController {
    var shiftid: String!
    
    @IBOutlet var beginDatePicker: UIDatePicker!
    
    @IBOutlet var endDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gsSetupNavBar()
        let dates = App.teamSettings.getShiftDates(id: shiftid)
        beginDatePicker.date = dates.begin
        endDatePicker.date = dates.end
    }

    @IBAction func saveButtonPressed() {
        let dates = GSShiftDates(begin: beginDatePicker.date, end: endDatePicker.date)

        App.teamSettings.editShift(id: shiftid, dates: dates)

        DB.save(settings: App.teamSettings)

        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func renameButtonPressed() {
        let alert = UIAlertController(title: __("Update Shift"), message: nil, preferredStyle: .alert)
        
        let update = UIAlertAction(title: __("Update"), style: .default) { _ in
            let shiftName = alert.textFields![0].text!

            App.teamSettings.shiftNames[self.shiftid] = shiftName
            DB.save(settings: App.teamSettings)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()
        alert.textFields?[0].placeholder = "Shift title"
        alert.textFields?[0].text = App.teamSettings.shiftNames[shiftid]
        alert.addAction(update)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
}
