//
//  LogController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/7/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class LogController: UITableViewController {
    
    //@IBOutlet var logTable: UITableView!
    
    // Objects shared from Login @ InstanceController
    var passedSession = NSURLSession.sharedSession()
    var passedInstance:String = ""
    var passedPort:String = ""
    var passedHostIP:String = ""
    
    // Entry passed to AlertController
    var passedEntry:String = ""
    
    // Set initially to 1 for testing
    var metricCount: Int = 0
    
    // Instantiate JSON Array
    var jsonContent:[(String)] = []
    var jsonContentKey:[String] = []
    var keyList:String = ""
    var list:String = ""
    
    // Refresher Object
    var refresher: UIRefreshControl!
    
    // Selected Alert
    var selectedAlert:String? = nil
    var selectedAlertIndex:Int? = nil
    
    var dict = Dictionary<String, String>()
    
    var sortedKeys:[String] = []
    
    // Refresh drag down
    func refresh() {
        print("Refreshed")
        // Use localhost:57773 when working at home!
        //let urlPath = "http://localhost:57773/csp/mobile/Test.Login.cls"
        let urlPath = "http://" + (passedHostIP) + ":" + (passedPort) + "/csp/mobile/Pulse.AlertLog.cls"
        print(urlPath)
        let url = NSURL(string: urlPath)
        let session = passedSession
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            //println(data)
            var state = ""
            
            if (error != nil) {
                print(error)
            } else {
                
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.metricCount = jsonResult.count
                let json = JSON(jsonResult)
                
                for (index, subJson): (String, JSON) in json {
                    
                    self.keyList = index
                    self.list = subJson.string!
                    
                    self.dict.updateValue(self.list, forKey: self.keyList)
                    
                    self.jsonContentKey.append(self.keyList)
                    self.jsonContent.append(self.list)
                    //println(self.jsonContentKey)
                    //println(self.jsonContent)
                }
                self.sortedKeys = self.jsonContentKey.sort(<)
                //println(self.dict)
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
            
        })
        
        task.resume()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //   MethName  ObjName    Datatype                                        Has 2 return Int
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return metricCount
    
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //sortedKeys.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        //}
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let escalateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Escalate", handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            let shareMenu = UIAlertController(title: nil, message: "Share Using", preferredStyle: .ActionSheet)
            
            let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default, handler: nil)
            let phoneAction = UIAlertAction(title: "Call", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(emailAction)
            shareMenu.addAction(phoneAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        
        escalateAction.backgroundColor = UIColor(red: 245/255, green: 180/255, blue: 0, alpha: 1)
        
        return [escalateAction]
        }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell (style: UITableViewCellStyle.Value1, reuseIdentifier: "LogCell")
        
        //cell.textLabel?.text = jsonContentKey[indexPath.row]
        //cell.detailTextLabel?.text = jsonContent[indexPath.row]
        
        cell.textLabel?.text = sortedKeys[indexPath.row]
        cell.detailTextLabel?.text = dict[cell.textLabel!.text!]
        
        
        if indexPath.row == selectedAlertIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedAlertIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedAlertIndex = indexPath.row + 1
        passedEntry = String(selectedAlertIndex!)
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.performSegueWithIdentifier("ViewSelectedAlert", sender: self)
    }
    
    // Segue to AlertController and display the selected Alert
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewSelectedAlert" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let viewAlertController = nav.topViewController as! AlertController
            
            viewAlertController.passedHostIP = passedHostIP
            viewAlertController.passedInstance = passedInstance
            viewAlertController.passedPort = passedPort
            viewAlertController.passedEntry = passedEntry

            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                selectedAlertIndex = indexPath?.row
                print(selectedAlertIndex)
                if let index = selectedAlertIndex {
                  //selectedAlert = alerts[index]
                    
                }
            }
        }
        if segue.identifier == "viewInstance" {
            
            let secondVC: TestController = segue.destinationViewController as! TestController
            
            secondVC.passedHostIP = passedHostIP
            secondVC.passedInstance = passedInstance
            secondVC.passedPort = passedPort
    }
  }
}