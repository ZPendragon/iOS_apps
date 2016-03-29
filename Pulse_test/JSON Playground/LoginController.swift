//
//  LoginController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/3/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    var userTouchID: String = ""
    @IBOutlet var password: UITextField!
    var passwordTouchID: String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let MyKeychainWrapper = KeychainWrapper()
    @IBOutlet var touchIDButton: UIButton!
    var error: NSError?
    var context = LAContext()
    // true sender ensures segue will not fire if login invalid
    var trueSender: Bool = false
    var session = NSURLSession.sharedSession()
    
    
    // General alert function
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Invalid Input", message: "Please enter a valid username and password.")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            
            let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLoginKey == false {
                NSUserDefaults.standardUserDefaults().setValue(self.username.text, forKey: "username")
                
            }
            MyKeychainWrapper.mySetObject(password.text, forKey: kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            displayAlert("Success!", message: "Please login with your username and password.")
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        // results in successful segue if previously authenticated
        if username.text == "" || password.text == "" {
            
            displayAlert("Invalid Input", message: "Please use a valid username and password.")
            
        } else {
            
            let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLoginKey == false {
                NSUserDefaults.standardUserDefaults().setValue(self.username.text, forKey: "username")
            }
            
            // mySetObject & writeToKeychain save the password to Keychain. hasLoginKey in NSUserDefaults to true to indicate that a password has been saved to the keychain.
            // Comment out Top 2 to not add extra password(s)
            //MyKeychainWrapper.mySetObject(password.text, forKey: kSecValueData)
            //MyKeychainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if checkLogin(username.text!, password: password.text!) {
                trueSender = true
                self.performSegueWithIdentifier("ShowInstance", sender: self)
                
            } else if checkLogin(username.text!, password: password.text!) == false {
                let alert = UIAlertView()
                alert.title = "Unable to Login"
                alert.message = "Wrong username or password."
                alert.addButtonWithTitle("OK")
                alert.show()
                //Cannot send dummy segue because we are force unwrapping when calling performSegueWithIdentifier
                 //self.performSegueWithIdentifier("NoSeg", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For the Login Page, the status bar is set to default, dark color
        UIApplication.sharedApplication().statusBarStyle = .Default
        navigationController?.hidesBarsOnTap = true
        // Need to pass in the text fields that should be controlled by the delegate
        self.username.delegate = self
        self.password.delegate = self
        
        touchIDButton.hidden = true
        
        do {
            try context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics)
            
            touchIDButton.hidden = false
            
        } catch var error1 as NSError {
            error = error1
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Changes the statusBarStyle for this specific controller and then changes it back
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
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
    
    func post(params : Dictionary<String, String>, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch let error as NSError {
            err = error
            request.HTTPBody = nil
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //println(data)
            //println(url)
           
            //println("Response: \(response)")
           _ = "No message"
    
        })
        
        task.resume()
    }
    
    @IBAction func touchIDLogin(sender: AnyObject) {
        //check whether the device is Touch ID capable.
        do {
            try context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics)
            
            // 2. If the device does support Touch ID, use evaluatePolicy to begin the policy evaluation prompt the user for Touch ID authentication.
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID",
                reply: { (success: Bool, error: NSError? ) -> Void in
                    
                    // 3. By default, the policy evaluation happens on a private thread, code jumps back to the main thread so it can update the UI.
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            self.trueSender = true
                            self.userTouchID = (NSUserDefaults.standardUserDefaults().valueForKey("username") as? String)!
                            //For retrieving the complete dictionary representation of user defaults:
                            // println(NSUserDefaults.standardUserDefaults().dictionaryRepresentation());
                            //For retrieving the keys:
                            // println(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys.array);
                            //For retrieving the values:
                            // println(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().values.array);
                            self.username.text = self.userTouchID
                            
                            self.passwordTouchID = (self.MyKeychainWrapper.myObjectForKey("v_Data") as? String)!
                            self.password.text = self.passwordTouchID
                            
                            self.performSegueWithIdentifier("ShowInstance", sender: self)
                        }
                        
                        if error != nil {
                            var title: String
                            var message: String
                            var showAlert: Bool
                            
                            // 4.
                            switch(error!.code) {
                            case LAError.AuthenticationFailed.rawValue:
                                title = "Error"
                                message = "There was a problem verifying your identity."
                                showAlert = true
                            case LAError.UserCancel.rawValue:
                                title = "Returning to Login"
                                message = "You pressed cancel."
                                showAlert = true
                            case LAError.UserFallback.rawValue:
                                title = "Returning to Login"
                                message = "Please enter a valid username and password."
                                showAlert = true
                            default:
                                title = "Error"
                                showAlert = true
                                message = "Touch ID may not be configured"
                            }
                            
                            var alert = UIAlertView()
                            alert.title = title
                            alert.message = message
                            alert.addButtonWithTitle("OK")
                            if showAlert {
                                alert.show()
                            }
                            
                        }
                    })
                    
            })
        } catch var error1 as NSError {
            error = error1
            // 5.
            var alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Touch ID not available"
            alert.addButtonWithTitle("Darn!")
            alert.show()
        }
        
    }

    func checkLogin(username: String, password: String ) -> Bool {
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? NSString &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
                //println(password)
                //println(username)
                return true
        } else {
            return false
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "ShowTest" && trueSender == true {
             return true
        }
        else if identifier == "ShowInstance" {
            return true
        }
        else {
        // by default do NOT perform the segue transition
        return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "ShowTest" {
        let secondVC: TestController = segue.destinationViewController as! TestController
        
        secondVC.passedSession = session
        }
    }
    
    
}