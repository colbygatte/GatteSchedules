//
//  CreateNewTeamViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/15/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class CreateNewTeamViewController: UIViewController {
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pw1TextField: UITextField!
    @IBOutlet weak var pw2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var createTeamButtonImageView: UIImageView!
    
    var fontSize: CGFloat = 16.0
    var keyboardShowingYPosition: Int? = nil
    
    var delegate: FirstTimeLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: view.window)
        
        
        logoContainerView.backgroundColor = UIColor.hexString(hex: "91A7B3")
        view.backgroundColor = UIColor.hexString(hex: "E3E3E3")
        
        let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapEndEditing)
        
        let textFields = [teamNameTextField, emailTextField, pw1TextField, pw2TextField, nameTextField]
        for textField in textFields {
            textField?.font = nil
            textField?.font = UIFont(name: "OpenSans-Light", size: fontSize)
            textField?.delegate = self
        }
        
        let createTeamButtonTap = UILongPressGestureRecognizer(target: self, action: #selector(loginButtonTapped(recognizer:)))
        createTeamButtonTap.minimumPressDuration = 0
        createTeamButtonImageView.addGestureRecognizer(createTeamButtonTap)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("showing")
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if keyboardShowingYPosition == nil {
            keyboardShowingYPosition = Int(-keyboardHeight) + (Int(view.frame.height) - Int(backButton.frame.minY))
        }
        
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(keyboardShowingYPosition!), width: view.frame.width, height: view.frame.height)
        
        UIView.animate(withDuration: TimeInterval(0.2)) { 
            self.logoImageView.alpha = 0.0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("hiding")
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        keyboardShowingYPosition = nil
        
        UIView.animate(withDuration: TimeInterval(0.2)) {
            self.logoImageView.alpha = 1.0
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func loginButtonTapped(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("began")
            createTeamButtonImageView.image = UIImage(named: "createteam_button_pressed.png")
        } else if recognizer.state == .ended {
            createTeamButtonImageView.image = UIImage(named: "createteam_button.png")
            if let pw1 = pw1TextField.text, let pw2 = pw2TextField.text, let email = emailTextField.text, let teamName = teamNameTextField.text, let name = nameTextField.text {
                if pw1 == pw2 {
                    DB.createUser(email: email, password: pw1, completion: { user, error in
                        if error == nil {
                            let teamid = DB.create(team: teamName)
                            let gsUser = GSUser(uid: user!.uid, email: email, name: name, teamid: teamid, permissions: App.Permissions.manager, positions: [], shifts: [])
                            DB.save(user: gsUser)
                            self.delegate?.firstTimeLoginSuccess(user: gsUser)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print(error?.localizedDescription)
                        }
                    })
                }

            }
        }
    }
}



extension CreateNewTeamViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.font = nil
        textField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.font = nil
        textField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
}
