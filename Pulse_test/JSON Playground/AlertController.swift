//
//  AlertController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 8/10/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import Foundation
import UIKit

class AlertController: UITableViewController {

    //@IBOutlet var logTable: UITableView!
    
    // Session shared from Test
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
    
    // Selected Alert
    var selectedAlert:String? = nil
    var selectedAlertIndex:Int? = nil
    
    // IndexPath for Row in Table
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    
    // General alert function
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            // This pushes InstanceController off the current stack, cant have that.
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Exit action to move from LogController to AlertController
    @IBAction func selectedAlert(segue:UIStoryboardSegue) {
        if let LogController = segue.sourceViewController as? LogController,
            selectedAlert = LogController.selectedAlert {
                //self.navName.title = selectedAlert
        }
    }
    
    // Refresher Object
    //var refresher: UIRefreshControl!
    
    // Refresh drag down
    /*func refresh() {
        println("Refreshed")
        // Use localhost:57773 when working at home!
        //let urlPath = "http://localhost:57773/csp/mobile/Test.Login.cls"
        let urlPath = "http://kzeckser.iscinternal.com/csp/mobile/Test.Extract.cls"
        let url = NSURL(string: urlPath)
        let session = passedSession
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println(data)
            var state = ""
            
            if (error != nil) {
                println(error)
            } else {
                
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                self.metricCount = jsonResult.count
                let json = JSON(jsonResult)
                for (index: String, subJson: JSON) in json {
                    
                    self.keyList = index
                    self.list = subJson.string!
                    
                    self.jsonContentKey.append(self.keyList)
                    self.jsonContent.append(self.list)
                }
                
                self.logTable.reloadData()
                self.refresher.endRefreshing()
            }
            
        })
        
        task.resume()
        
        
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // might need to reload at open
        self.navigationController!.navigationBarHidden = false
        // Need getEntry() in DidLoag and DidAppear to work
        getEntry()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getEntry()
    }
    
    func getEntry() {
        // Use localhost:57773 when working at home!
        //let urlPath = "http://localhost:57773/csp/mobile/Test.Extract.cls"
        let urlPath = "http://" + (passedHostIP) + ":" + (passedPort) + "/csp/mobile/Pulse.ExtractAlert.cls?num=" + (passedEntry)
        let url = NSURL(string: urlPath)
        let session = passedSession
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print(data)
            var state = ""
            
            if (error != nil) {
                print(error)
            } else {
                
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.metricCount = jsonResult.count
                let json = JSON(jsonResult)
                for (index, subJson): (String, JSON) in json {
                    
                    self.keyList = index
                    self.list = subJson.string!
                    
                    self.jsonContentKey.append(self.keyList)
                    self.jsonContent.append(self.list)
                }
                
                self.tableView.reloadData()
                
            }
            
        })
        
        task.resume()
        self.tableView.reloadData()
    }
    
    
 
    @IBAction func diagReport(sender: UIButton!) {
        //let indexPath = self.tableView!.indexPathForSelectedRow()!
        //println(selectedIndexPath)
        //let selectedCell = self.tableView!.cellForRowAtIndexPath(selectedIndexPath) as! AlertFooterCell!
        let urlPath = "http://" + (passedHostIP) + ":" + (passedPort) + "/csp/mobile/Pulse.WRCDiagnostic.cls?num=" + ("1")
        let url = NSURL(string: urlPath)
        let session = passedSession

        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print(data)
            self.displayAlert("Running Buttons", message: "This process will take approximately 5 minutes to complete. Your report will be located in the mgr directory")
            if (error != nil) {
                print(error)
            }
        })
        
        task.resume()
    }
    
    @IBAction func contact(sender: UIButton!) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        // Return the number of sections.
        return 1
    }
    
    //   MethName  ObjName    Datatype                                        Has 2 return Int
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return metricCount
        
    }
    
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell (style: UITableViewCellStyle.Value1, reuseIdentifier: "AlertCell") as! AlertCell
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath) as! AlertCell
        cell.dataLabel.text = jsonContent[indexPath.row]
    
    
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! AlertHeaderCell
        
        switch (section) {
        case 0:
        headerCell.headerLabel.text = passedEntry;
        default:
            headerCell.headerLabel.text = passedEntry;
        }
        return headerCell
    }
    
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        //footerView.backgroundColor = UIColor(red: 38/255, green: 160/255, blue: 218/255, alpha: 1)
        //return footerView
        let  footerCell = tableView.dequeueReusableCellWithIdentifier("FooterCell") as! AlertFooterCell
        
        //footerCell.diagReport.tag = indexPath.row
        footerCell.diagReport.addTarget(self, action:"diagReport:", forControlEvents: .TouchUpInside)
        
        return footerCell
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewAlertLog" {
            
            //let nav = segue.destinationViewController as! UINavigationController
            //let viewLogController = nav.topViewController as! LogController

            let secondVC: LogController = segue.destinationViewController as! LogController
    
            secondVC.passedHostIP = passedHostIP
            secondVC.passedInstance = passedInstance
            secondVC.passedPort = passedPort
        }
    }
    
}