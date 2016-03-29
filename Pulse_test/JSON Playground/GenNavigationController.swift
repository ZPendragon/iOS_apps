//
//  GenNavigationController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/14/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit

class GenNavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Status bar white font
        //self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        //self.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
    }

}