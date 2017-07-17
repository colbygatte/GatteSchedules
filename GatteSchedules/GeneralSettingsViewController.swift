//
//  GeneralSettingsViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/30/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class GeneralSettingsViewController: UIViewController {
    @IBOutlet weak var teamNameTextField: UITextField!
    
    @IBOutlet weak var daysLabel: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        stepper.maximumValue = 20
        stepper.minimumValue = 1
        stepper.autorepeat = true

        daysLabel.text = String(App.teamSettings.daysPriorRestriction)
        stepper.value = Double(App.teamSettings.daysPriorRestriction)
        teamNameTextField.text = App.teamSettings.teamName
    }

    @IBAction func stepperValueChanged(sender: UIStepper) {
        daysLabel.text = Int(sender.value).description
    }

    @IBAction func saveButtonPressed() {
        if let teamName = teamNameTextField.text {
            App.teamSettings.teamName = teamName
            App.teamSettings.daysPriorRestriction = Int(stepper.value)

            DB.save(settings: App.teamSettings)

            _ = navigationController?.popViewController(animated: true)
        }
    }
}
