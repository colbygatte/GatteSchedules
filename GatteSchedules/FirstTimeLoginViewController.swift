//
//  FirstTimeLoginViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/3/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

// remember: auth listener is not running while we are in here (because it is accessed only
// from the login view controller

import UIKit

protocol FirstTimeLoginDelegate {
    func firstTimeLoginSuccess(user: GSUser)
}

class FirstTimeLoginViewController: UIViewController {
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButtonImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    var fontSize: CGFloat = 16.0
    
    var pendingUser: GSPendingUser?
    var delegate: FirstTimeLoginDelegate?
    var passwordPopup: FirstTimeLoginPopupView = FirstTimeLoginPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoContainerView.backgroundColor = UIColor.hexString(hex: "91A7B3")
        view.backgroundColor = UIColor.hexString(hex: "E3E3E3")
        
        let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapEndEditing)
        
        let loginButtonTap = UILongPressGestureRecognizer(target: self, action: #selector(loginButtonTapped(recognizer:)))
        loginButtonTap.minimumPressDuration = 0
        loginButtonImageView.addGestureRecognizer(loginButtonTap)
        
        
        emailTextField.font = UIFont(name: "OpenSans-Light", size: fontSize)
        codeTextField.font = UIFont(name: "OpenSans-Light", size: fontSize)
        
        emailTextField.delegate = self
        codeTextField.delegate = self
        
        passwordPopup.delegate = self
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // step 1: get pending user, check if email matches
    func loginButtonTapped(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("began")
            loginButtonImageView.image = UIImage(named: "login_button_pressed.png")
        } else if recognizer.state == .ended {
            loginButtonImageView.image = UIImage(named: "login_button.png")
            
            // Validate
            if let code = codeTextField.text?.lowercased(), let email = emailTextField.text?.lowercased() {
                if code.characters.count != 0 && email.characters.count != 0 {
                    
                    DB.getPendingUser(code: code) { pendingUserSnap in
                        if pendingUserSnap.childrenCount == 0 {
                            self.quickAlert(title: nil, message: "Invalid information")
                        } else {
                            self.pendingUser = GSPendingUser(snapshot: pendingUserSnap)
                            
                            if self.pendingUser!.email == email {
                                self.getPassword()
                            }
                        }
                    }
                    
                } else {
                    self.quickAlert(title: nil, message: "Please fill out all fields.")
                }
            } else {
                self.quickAlert(title: nil, message: "Please fill out all fields.")
            }
        }
    }
    
    // step 2: get user password & validate matching to retentered password
    func getPassword() {
        passwordPopup.frame = (view.window?.frame)!
        passwordPopup.setFrame()
        passwordPopup.show()
        view.addSubview(passwordPopup)
    }
    
    // step 3: create the user with the email & password
    func gotPassword(_ password: String) {
        createNewUser(from: self.pendingUser!, password: password)
    }
    
    // step 4: create the new user
    // this will automatically log in the user (firebase always does this when creating a user)
    func createNewUser(from pendingUser: GSPendingUser, password: String) { // probably don't need to pass pendingUser, it's in self
        
        DB.createUser(email: pendingUser.email, password: password) { firUser, error in
            // all these optionals and unwrapping, do better here:
            if error == nil {
                let gsUser = GSUser(uid: (firUser?.uid)!, email: (self.pendingUser?.email)!, name: (self.pendingUser?.name)!, teamid: (self.pendingUser?.teamid)!, permissions: "normal", positions: [], shifts: [])
                DB.save(user: gsUser)
                
                DB.deletePendingUser(code: (self.pendingUser?.code)!)
                
                self.delegate?.firstTimeLoginSuccess(user: gsUser)
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension FirstTimeLoginViewController: FirstTimeLoginPopupViewDelegate {
    func loginButtonPressed(pw1: String?, pw2: String?) {
        if let pw3 = pw1, let pw4 = pw2 {
            if pw3 == pw4 {
                passwordPopup.dismiss()
                gotPassword(pw3)
                
            } else {
                quickAlert(title: nil, message: "Password do not match.")
            }
        }
    }
}

extension FirstTimeLoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.font = nil
        textField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.font = nil
        textField.font = UIFont(name: "OpenSans-Light", size: fontSize)
    }
}
