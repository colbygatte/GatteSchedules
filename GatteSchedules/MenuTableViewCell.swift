//
//  MenuTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/8/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    var shouldToggle: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = App.Theme.menuBackgroundColor
        self.textLabel?.textColor = App.Theme.menuTextColor
    }
}
