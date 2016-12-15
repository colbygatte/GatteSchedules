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
        UIView.animate(withDuration: TimeInterval(0.3), animations: {
            if self.requesting == "" {
                self.requesting = "off"
                self.requestingLabel.text = "Off"
            } else if self.requesting == "off" {
                self.requesting = "work"
                self.requestingLabel.text = "Work"
            } else {
                self.requesting = ""
                self.requestingLabel.text = ""
            }
        })
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
