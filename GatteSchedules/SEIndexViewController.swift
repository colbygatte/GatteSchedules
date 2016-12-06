//
//  ScheduleMakerIndexViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEIndexViewController: UIViewController {
    @IBOutlet var datePicker: UIPickerView!
    var datesForPicker: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        datesForPicker = []
        
        populateDates()
    }
    
    func populateDates() {
        let calendar = Calendar(identifier: .gregorian)
        var component = DateComponents()
        component.weekday = 1
        
        var date = calendar.nextDate(after: Date(), matching: component, matchingPolicy: .nextTime)
        
        let dateString = App.formatter.string(from: date!)
        datesForPicker.append(dateString)
        
        for _ in 0...9 {
            date = date!.addingTimeInterval(TimeInterval(60*60*24*7))
            let newDateString = App.formatter.string(from: date!)
            datesForPicker.append(newDateString)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleEditorViewDays" {
            let pickedIndex = datePicker.selectedRow(inComponent: 0)
            let date = App.formatter.date(from: datesForPicker[pickedIndex])
            
            let scheduleRef = DB.createSchedule(date: date!)
            let schedule = GSSchedule(firebaseRef: scheduleRef, createdBy: App.loggedInUser.uid)
            
            let scheduleEditorListDayVC = segue.destination as! SEListDaysTableViewController
            scheduleEditorListDayVC.schedule = schedule
        }
    }
}

extension SEIndexViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datesForPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datesForPicker[row]
    }
}
