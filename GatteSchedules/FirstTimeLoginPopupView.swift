//
//  FirstTimeLoginPopupView.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 1/8/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

protocol FirstTimeLoginPopupViewDelegate {
    func loginButtonPressed(pw1: String?, pw2: String?)
}

class FirstTimeLoginPopupView: UIView {
    var delegate: FirstTimeLoginPopupViewDelegate?

    var fontSize: CGFloat = 16.0

    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popup: UIView!
    
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    @IBOutlet weak var pwTextField1: UITextField!
    
    @IBOutlet weak var pwTextField2: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    func setup() {
        Bundle.main.loadNibNamed("FirstTimeLoginPopupView", owner: self, options: nil)

        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        transparentBackgroundView.addGestureRecognizer(backgroundTap)

        popupView.addSubview(transparentBackgroundView)
        popupView.bringSubview(toFront: popup)

        pwTextField2.isSecureTextEntry = true
        pwTextField1.isSecureTextEntry = true

        addSubview(popupView)
    }

    func setFrame() {
        popupView.frame = frame
        transparentBackgroundView.frame = frame
    }

    func show() {
        pwTextField1.becomeFirstResponder()
        
        alpha = 0
        
        popup.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        UIView.animate(withDuration: TimeInterval(0.2)) {
            self.alpha = 1
        }
    }

    func dismiss() {
        UIView.animate(withDuration: TimeInterval(0.2)) {
            self.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.removeFromSuperview()
        })
    }

    @IBAction func loginButtonPressed() {
        delegate?.loginButtonPressed(pw1: pwTextField1.text, pw2: pwTextField2.text)
    }
}

