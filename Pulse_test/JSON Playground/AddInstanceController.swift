//
//  AddInstanceController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/9/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit

class AddInstanceController: UITableViewController{
 
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ipTextField: UITextField!
    @IBOutlet var portTextField: UITextField!
    
    var instance:Instance!
    // true sender ensures segue will not fire if login invalid
    var trueSender: Bool = false
    
    // General alert function
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //if the user tapped the first cell, the app should activate the text field
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
        if indexPath.section == 1 {
            nameTextField.becomeFirstResponder()
        }
        if indexPath.section == 2 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    // Tap away, close keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    // Hit enter, close keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func fieldCheck() -> Bool {
        
        if self.nameTextField == "" || self.ipTextField.text == "" || self.portTextField.text == "" {
            
            displayAlert("Missing Field(s)", message: "Please try again.")
            return false
        }
        else {
            return true
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "SaveInstanceDetail" {
            return fieldCheck().boolValue
            
        }
        if identifier == "cancelToInstanceController" {
            return true
        }
        else {
            // by default do NOT perform the segue transition
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveInstanceDetail" {
            instance = Instance(name: self.nameTextField.text, ip: self.ipTextField.text, port:self.portTextField.text)
            // Core Data implementation
            /*
            var secondVC: InstanceController = segue.destinationViewController as! InstanceController
            
            secondVC.tempname = self.nameTextField.text
            secondVC.tempip = self.ipTextField.text
            secondVC.tempport = self.portTextField.text
            */
        }
        
}
}