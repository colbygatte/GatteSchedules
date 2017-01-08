//
//  MainSectionHeaderView.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 1/8/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

class MainSectionHeaderView: UIView {
    @IBOutlet weak var sectionHeaderView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("MainSectionHeaderView", owner: self, options: nil)
        
        sectionTitleLabel.font = App.globalFontThick
        addSubview(sectionHeaderView)
    }
    
    func setFrame() {
        sectionHeaderView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}
