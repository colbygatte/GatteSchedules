//
//  DDPositionTableViewCell.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/13/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class DDPositionTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    var canSelect = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
