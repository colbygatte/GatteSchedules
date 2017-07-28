//
//  GSCheckbox.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 1/7/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

protocol GSCheckboxDelegate {
    func toggled(_ checkbox: GSCheckbox)
}

class GSCheckbox: UIView {
    var delegate: GSCheckboxDelegate?
    
    @IBOutlet weak var checkboxView: UIView!
    
    @IBOutlet weak var checkboxImageView: UIImageView!

    var on: Bool = false {
        didSet {
            setCheck()
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    func setup() {
        Bundle.main.loadNibNamed("GSCheckbox", owner: self, options: nil)

        addSubview(checkboxView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
        
        checkboxView.addGestureRecognizer(tap)
    }

    func setFrame() {
        checkboxView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        checkboxImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }

    func tapped(recognizer _: UITapGestureRecognizer) {
        on = !on
        
        setCheck()
    }

    func setCheck(animation: Bool = true) {
        let timeInterval = animation ? 0.2 : 0.0
        
        UIView.animate(withDuration: TimeInterval(timeInterval), animations: {
            self.checkboxImageView.alpha = self.on ? 1.0 : 0.2
        })
    }
}
