//
//  USVScheduleTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class USVScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    var day: GSUserDay!
    var shift: GSUserShift!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func set(day: GSUserDay, shift: GSUserShift) {
        self.day = day
        self.shift = shift
        
        var text : String = ""
        
        text += shift.shiftid
        text += ": "
        text += shift.position.positionid
        
        shiftLabel.textColor = UIColor.gray
        shiftLabel.text = App.teamSettings.getShift(id: shift.shiftid)
        positionLabel.text = App.teamSettings.getPosition(id: shift.position.positionid)
        
        resizeLabels()
    }
    
    func setIsOff() {
        shiftLabel.textColor = UIColor.gray
        shiftLabel.text = "OFF"
        positionLabel.text = ""
        resizeLabels()
    }
    
    func setIsNotPublished() {
        shiftLabel.textColor = UIColor.gray
        
        if App.loggedInUser.permissions == App.Permissions.manager {
            shiftLabel.text = "Edit day/Put in a request"
        } else {
            shiftLabel.text = "Put in a request"
        }
        
        positionLabel.text = ""
        resizeLabels()
    }
    
    func resizeLabels() {
        shiftLabel.sizeToFit()
        positionLabel.sizeToFit()
    }
}
