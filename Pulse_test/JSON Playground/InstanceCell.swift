//
//  InstanceCell.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/9/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit

class InstanceCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    
    @IBOutlet var usernameCell: UITextField!
    @IBOutlet var passwordCell: UITextField!
    @IBOutlet var login: UIButton!
    @IBOutlet var touchID: UIButton!
    @IBOutlet var successImage: UIImageView!
    
    class var expandedHeight: CGFloat { get { return 250 } }
    class var defaultHeight: CGFloat  { get { return 60  } }
    
    func checkHeight() {
        
        usernameCell.hidden = (frame.size.height < InstanceCell.expandedHeight)
        passwordCell.hidden = (frame.size.height < InstanceCell.expandedHeight)
        login.hidden = (frame.size.height < InstanceCell.expandedHeight)
        touchID.hidden = (frame.size.height < InstanceCell.expandedHeight)
        successImage.hidden = (frame.size.height < InstanceCell.expandedHeight)
            }
    
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        checkHeight()
    }
    func ignoreFrameChanges() {
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
}

