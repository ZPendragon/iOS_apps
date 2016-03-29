//
//  AlertFooterCell.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/26/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import UIKit

class AlertFooterCell: UITableViewCell {

    @IBOutlet var diagReport: UIButton!
    @IBOutlet var contact: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
