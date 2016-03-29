//
//  InstanceController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/9/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
//import CoreData

let cellID = "InstanceCell"

class InstanceController: UITableViewController{
    // Sample Data
    var instances: [Instance] = instancesData
    //var cell: InstanceCell!
    // Core Data (Eventually)
    //var instances = [NSManagedObject]()
    
    // Objects for checkmark
    var selectedInstance:String? = nil
    var selectedInstanceIndex:Int? = nil
    
    // Core Data Implementation
    //var tempname: String? = nil
    //var tempip: String? = nil
    //var tempport: String? = nil
    
    // Expand/Collapse TableView
    //var selectedIndexPath: NSIndexPath? = nil
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
    
    // Initialize Instance Configuration
    var inputUsername: String = ""
    var inputPassword: String = ""
    var inputName: String = ""
    var inputHostIP: String = ""
    var inputPort: String = ""
    // true sender ensures segue will not fire if login invalid
    var trueSender: Bool = false
    var session = NSURLSession.sharedSession()
    let MyKeychainWrapper = KeychainWrapper()
    // Initialize TouchID objects
    var userTouchID: String = ""
    var passwordTouchID: String = ""
    var error: NSError?
    var context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.navigationBarHidden = false
        navigationController?.navigationBarHidden = false
    }
    
    // General alert function
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            // This pushes InstanceController off the current stack, cant have that.
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func login(sender: UIButton!) {
        _ = self.tableView!.indexPathForSelectedRow!
        //println(indexPath)
        let selectedCell = self.tableView!.cellForRowAtIndexPath(selectedIndexPath) as! InstanceCell!
        print(selectedCell)
        inputUsername = selectedCell.usernameCell.text!
        inputPassword = selectedCell.passwordCell.text!
        inputName = selectedCell.nameLabel.text!
        inputHostIP = selectedCell.ipLabel.text!
        inputPort = selectedCell.portLabel.text!
        //println(inputUsername)
        //println(inputPassword)
        print(inputName)
        print(inputHostIP)
        print(inputPort)
        // results in successful segue if previously authenticated
        if inputUsername == "" || inputPassword == "" {
            
            displayAlert("Invalid Input", message: "Please use a valid username and password.")
            
        } else {
            
            let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLoginKey == false {
                NSUserDefaults.standardUserDefaults().setValue(inputUsername, forKey: "username")
            }
            
            // mySetObject & writeToKeychain save the password to Keychain. hasLoginKey in NSUserDefaults to true to indicate that a password has been saved to the keychain.
            // Comment out Top 2 to not add extra password(s)
            //MyKeychainWrapper.mySetObject(password.text, forKey: kSecValueData)
            //MyKeychainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if checkLogin(inputUsername, password: inputPassword) {
                trueSender = true
                // Use localhost:57773 when working at home!
                //self.post(["CacheUserName": username.text, "CachePassword": password.text], url: "http://localhost:57773/csp/mobile/Pulse.Content.cls?&CacheUserName=" + (username.text) + "&CachePassword=" + (password.text) ) { (succeeded: Bool, msg: String) -> () in
    
                self.post(["CacheUserName": inputUsername, "CachePassword": inputPassword], url: "http://" + (inputHostIP) + ":" + (inputPort) + "/csp/mobile/Pulse.InstanceOverview.cls?&CacheUserName=" + (inputUsername) + "&CachePassword=" + (inputPassword) ) { (succeeded: Bool, msg: String) -> () in
                    // succeeded returns nil, so we cant show alert 8/5
                    
                    print(succeeded.boolValue)
                    let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "OK")
                    if(succeeded) {
                        alert.title = "Success!"
                        alert.message = msg
                        self.displayAlert(alert.title, message: alert.message!)
                    }
                    else {
                        // Not working 8/5
                        alert.title = "Connection failed"
                        alert.message = msg
                        self.displayAlert(alert.title, message: alert.message!)
                    }
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Show the alert
                        alert.show()
                        print("We have connected to cache")
                    })
                    
                }
            
                self.performSegueWithIdentifier("ShowTest", sender: self)
                
            } else if checkLogin(inputUsername, password: inputPassword) == false {
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
            var msg = "No message"
            
        })
        
        task.resume()
    }
    
    @IBAction func touchIDlogin(sender: UIButton) {
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
                            self.inputUsername = self.userTouchID
                            
                            self.passwordTouchID = (self.MyKeychainWrapper.myObjectForKey("v_Data") as? String)!
                            self.inputPassword = self.passwordTouchID
                            let indexPath = self.tableView!.indexPathForSelectedRow!
                            let selectedCell = self.tableView!.cellForRowAtIndexPath(self.selectedIndexPath) as! InstanceCell!
                            self.inputName = selectedCell.nameLabel.text!
                            self.inputHostIP = selectedCell.ipLabel.text!
                            self.inputPort = selectedCell.portLabel.text!
                            
                            
                            // Use localhost:57773 when working at home!
                            //self.post(["CacheUserName": self.username.text, "CachePassword": self.password.text], url: "http://localhost:57773/csp/mobile/Pulse.Content.cls?&CacheUserName=" + (self.username.text) + "&CachePassword=" + (self.password.text) ) { (succeeded: Bool, msg: String) -> () in
                            
                            self.post(["CacheUserName": self.inputUsername, "CachePassword": self.inputPassword], url: "http://" + (self.inputHostIP) + ":" + (self.inputPort) + "/csp/mobile/Pulse.Content.cls?&CacheUserName=" + (self.inputUsername) + "&CachePassword=" + (self.inputPassword) ) { (succeeded: Bool, msg: String) -> () in
                                
                            }
                            
                            //println(url)
                            self.performSegueWithIdentifier("ShowTest", sender: self)
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
    
    
    @IBAction func cancelToInstanceController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveInstanceDetail(segue:UIStoryboardSegue) {
        if let addInstanceController = segue.sourceViewController as? AddInstanceController {
            
            //add the new instance to the instance array
            //Throws an error w/ null fields check from AddInstance
            instances.append(addInstanceController.instance)
           
         /*
            // Core Date Model
            self.saveFields(tempname!, ip: tempip!, port: tempport!)
            self.tableView.reloadData()
         */
            
                
            //update the tableView
            let indexPath = NSIndexPath(forRow: instances.count-1, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
  /*
    func saveFields(name: String, ip: String, port: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Instance",
            inManagedObjectContext:
            managedContext)
        
        let instance = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        instance.setValue(name, forKey: "name")
        instance.setValue(ip, forKey: "ip")
        instance.setValue(port, forKey: "port")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        instances.append(instance)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Instance")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            instances = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
 */
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    if editingStyle == UITableViewCellEditingStyle.Delete {
    
            instances.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return instances.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! InstanceCell
            let instance = instances[indexPath.row] as Instance
            //Dont think below is necessary, can set in Attribute inspector
            //cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if indexPath.row == selectedInstanceIndex {
                // Do stuff when cell is selected i.e. Checkmarks
            } else {
                // Do stuff when cell is deselected
                
            }
        
            cell.nameLabel.text = instance.name
            cell.ipLabel.text = instance.ip
            cell.portLabel.text = instance.port
            //cell.usernameCell.delegate = self
            //cell.passwordCell.delegate = self

            // Not Working -- TouchID Button should be hidden if device unsupported
            cell.touchID.hidden = true
        
            do {
                try context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics)
            
            cell.touchID.hidden = false
            
            } catch var error1 as NSError {
                error = error1
            }
        
            //inputUsername = cell.usernameCell.text
            //inputPassword = cell.passwordCell.text
            cell.login.tag = indexPath.row
            cell.login.addTarget(self, action:"login:", forControlEvents: .TouchUpInside)
        
         /*
            // Core Data Implementation
            let instance = instances[indexPath.row]
        
            cell.nameLabel.text = instance.valueForKey("name") as? String
            cell.ipLabel.text = instance.valueForKey("ip") as? String
            cell.portLabel.text = instance.valueForKey("port") as? String
        */
            return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //println("didSelectRowAtIndexPath was called")
        selectedIndexPath = indexPath
        
        // Begin updates for selected cell
        tableView.beginUpdates()
        
        //Other row is selected - need to deselect it
        if let index = selectedInstanceIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
        }
        
        selectedInstanceIndex = indexPath.row
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        // End updates for selected cell
        tableView.endUpdates()
        
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedIndexPath.row {
            return InstanceCell.expandedHeight
        } else {
            return InstanceCell.defaultHeight
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! InstanceCell).watchFrameChanges()
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! InstanceCell).ignoreFrameChanges()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "ShowTest" && trueSender == true {
            return true
        }
        else if identifier == "ShowInstance" {
            return true
        } else if identifier == "AddInstance" {
            return true
        } else if identifier == "ShowSettings" {
            return true
        }
        else {
            // by default do NOT perform the segue transition
            return false
        }
    }
    
    // Segue to TestController and display the selected Instance
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewSelectedInstance" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                selectedInstanceIndex = indexPath?.row
                //if let index = selectedInstanceIndex {
                  //  selectedInstance = instances[index]
                //}
            }
        }
        if segue.identifier == "ShowTest" {
            let secondVC: TestController = segue.destinationViewController as! TestController
            
            secondVC.passedSession = session
            secondVC.passedHostIP = inputHostIP
            secondVC.passedPort = inputPort
        }
        
    }

}