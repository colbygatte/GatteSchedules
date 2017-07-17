//
//  USVScheduleTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class USVScheduleTableViewCell: UITableViewCell {
    var day: GSUserDay!
    
    var shift: GSUserShift!
    
    var unpublishedAndCannotRequest = false

    var shiftLabelTextColor: UIColor!

    @IBOutlet weak var shiftLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        shiftLabelTextColor = UIColor.hexString(hex: "6A6A6A")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func set(day: GSUserDay, shift: GSUserShift) {
        self.day = day
        self.shift = shift

        shiftLabel.text = App.teamSettings.getShift(id: shift.shiftid)

        positionLabel.text = App.teamSettings.getPosition(id: shift.position.positionid)

        resizeLabels()
    }

    func setIsOff() {
        shiftLabel.textColor = shiftLabelTextColor
        shiftLabel.text = "OFF"
        positionLabel.text = ""
        resizeLabels()
    }

    func setIsNotPublishedAndCanRequest() {
        shiftLabel.textColor = shiftLabelTextColor

        unpublishedAndCannotRequest = false

        if App.loggedInUser.permissions == App.Permissions.manager {
            shiftLabel.text = "Edit day/Put in a request"
        } else {
            shiftLabel.text = "Put in a request"
        }

        positionLabel.text = ""
        
        resizeLabels()
    }

    func setIsNotPublishedAndCannotRequest() {
        shiftLabel.textColor = shiftLabelTextColor

        if App.loggedInUser.permissions == App.Permissions.manager {
            shiftLabel.text = "Edit day/Put in a request"
        } else {
            shiftLabel.text = "Unpublished"
            unpublishedAndCannotRequest = true
        }

        positionLabel.text = ""
        resizeLabels()
    }

    func resizeLabels() {
        shiftLabel.sizeToFit()
        positionLabel.sizeToFit()
    }
}
