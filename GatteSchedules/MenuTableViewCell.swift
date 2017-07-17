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
    
    @IBOutlet weak var customLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        backgroundColor = App.Theme.menuBackgroundColor
        
        textLabel?.textColor = App.Theme.menuTextColor
    }
}
