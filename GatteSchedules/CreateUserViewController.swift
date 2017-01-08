//
//  CreateUserViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var createUserButton: UIButton!
    
    var fontSize: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gsSetupNavBar()
        emailTextField.delegate = self
        nameTextField.delegate = self
        
        emailTextField.font = UIFont(name: "OpenSans-Light", size: fontSize)
        nameTextField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
    
    @IBAction func createUserButtonPressed() {
        createUserButton.isEnabled = false
        
        let email = emailTextField.text! // @@@@ validate data
        let name = nameTextField.text!
        let teamid = App.teamSettings.teamid // @@@@ why does this have to be unwrapped below?
        
        let code = DB.createPendingUser(name: name, email: email, teamid: teamid!)
        
        codeLabel.text = "Code for \(name): \(code)"
        
        //_ = navigationController?.popViewController(animated: true)
    }
}

extension CreateUserViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.font = nil
        textField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.font = nil
        textField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
}
