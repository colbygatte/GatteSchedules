//
//  USVScheduleTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/7/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class USVScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
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
        
        label.textColor = UIColor.gray
        label.text = text
    }
    
    func setIsOff() {
        label.textColor = UIColor.gray
        label.text = "OFF"
    }
    
    func setIsNotPublished() {
        label.textColor = UIColor.gray
        label.text = "not published"
    }
}
