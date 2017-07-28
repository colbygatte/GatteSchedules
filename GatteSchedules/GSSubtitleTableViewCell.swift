//
//  GSSubtitleTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 1/8/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

class GSSubtitleTableViewCell: GSTableViewCell {
    @IBOutlet weak var gsSubLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        gsLabel.font = App.globalFontThick?.withSize(20.0)
        gsSubLabel.font = App.globalFont?.withSize(12.0)
    }
}
