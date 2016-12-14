//
//  EditUserTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/14/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import BEMCheckBox

class EditUserTableViewCell: UITableViewCell {
    @IBOutlet weak var checkbox: BEMCheckBox!
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        checkbox.on = selected
    }

}
