//
//  GSPopup.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/15/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class GSPopup: UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Popup", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}
