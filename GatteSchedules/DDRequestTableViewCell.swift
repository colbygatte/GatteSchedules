//
//  DDRequestCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/11/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class DDRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var shiftNameLabel: UILabel!
    @IBOutlet weak var requestingLabel: UILabel!
    
    var requesting: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        requesting = ""
    }
    
    func toggleRequest() {
        if requesting == "" {
            requesting = "off"
            requestingLabel.text = "Off"
        } else if requesting == "off" {
            requesting = "work"
            requestingLabel.text = "Work"
        } else {
            requesting = ""
            requestingLabel.text = ""
        }
    }
    
    func setRequest(to: String) {
        if to == "off" {
            requestingLabel.text = "Off"
            requesting = to
        } else if to == "work" {
            requestingLabel.text = "Work"
            requesting = to
        }
    }
}
