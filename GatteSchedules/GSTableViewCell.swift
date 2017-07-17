//
//  GSTableViewCell.swift
//
//
//  Created by Colby Gatte on 1/8/17.
//
//

import UIKit

class GSTableViewCell: UITableViewCell {
    @IBOutlet weak var gsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
