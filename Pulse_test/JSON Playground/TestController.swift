//
//  ViewController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 7/20/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import UIKit


class TestController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var zv: UILabel!
    @IBOutlet var navName: UINavigationItem!
    @IBOutlet var testSwitch: UISwitch!
    @IBOutlet var systemState: UILabel!
    @IBOutlet var table: UITableView!
    
    // Set initially to 1 for testing
    var metricCount: Int = 0
    
    // Instantiate JSON Array
    var jsonContent:[(String)] = []
    var jsonContentKey:[String] = []
    var keyList:String = ""
    var list:String = ""
    
    // Refresher Object
    var refresher: UIRefreshControl!
    
    // SegementController Object
    @IBOutlet var segOption: UISegmentedControl!
    var segNum:Int = 0
    var consoleContent = ["Alert Log", "System Log", "Audit Log"]
    
    // Objects shared from Login @ InstanceController
    var passedSession = NSURLSession.sharedSession()
    var passedInstance:String = ""
    var passedPort:String = ""
    var passedHostIP:String = ""
    
    // Outlet to manipulate statusBar background color
    @IBOutlet var statusBarBackground: UIView!
    
    // Selected Log
    var selectedLog:String? = nil
    var selectedLogIndex:Int? = nil
    var tableView: UITableView!
    
    // Exit action to move from InstanceController to TestController
    @IBAction func selectedInstance(segue:UIStoryboardSegue) {
        if let InstanceController = segue.sourceViewController as? InstanceController, selectedInstance = InstanceController.selectedInstance {
                passedInstance = selectedInstance
                passedHostIP = InstanceController.inputHostIP
                passedPort = InstanceController.inputPort
        }
        if let LogController = segue.sourceViewController as? LogController {
                passedInstance = LogController.passedInstance
                passedHostIP = LogController.passedHostIP
                passedPort = LogController.passedPort
        }
    }

    
    // Segment Controller Function
    @IBAction func indexChanged(sender: AnyObject) {
    
        switch segOption.selectedSegmentIndex {
            
        case 0:
            print("Summary")
            segNum = 0
            self.table.reloadData()
            
        case 1:
            print("Logs & Alerts")
            segNum = 1
            self.table.reloadData()
            
        default:
            break
        }
        
    }
  
    // Refresh drag down
    func refresh() {
        print("Refreshed")
        // Use localhost:57773 when working at home!
        //let urlPath = "http://localhost:57773/csp/mobile/Pulse.Content.cls"
        //let urlPath = "http://kzeckser.iscinternal.com/csp/mobile/Pulse.Content.cls"
        
        let urlPath = "http://" + (passedHostIP) + ":" + (passedPort) + "/csp/mobile/Pulse.InstanceOverview.cls"
        print(urlPath)
        // cache.iscinternal.com will not work for external requests, so the request on the phone fails
        //let urlPath = "http://cache.iscinternal.com/csp/mobile/Pulse.Content.cls"
        let url = NSURL(string: urlPath)
        let session = passedSession
        //let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print(data)
            var state = ""
            
            if (error != nil) {
                print(error)
            } else {
                
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.metricCount = jsonResult.count
                self.navName.title = (jsonResult.objectForKey("Instance Name") as? String)
                self.systemState.text = (jsonResult.objectForKey("System State") as? String)
                let json = JSON(jsonResult)
                for (index, subJson): (String, JSON) in json {
                    
                    self.keyList = index
                    self.list = subJson.string!
                    
                    self.jsonContentKey.append(self.keyList)
                    self.jsonContent.append(self.list)
                }
                //self.navName.title = self.jsonContent[2]
                //self.systemState.text = self.jsonContent[1]
                //self.systemState.text = (jsonResult.objectForKey("System State") as? String)
                self.table.reloadData()
                self.refresher.endRefreshing()
            }
            
        })
        
        task.resume()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarBackground.backgroundColor = UIColor(red: 38/255, green: 160/255, blue: 218/255, alpha: 1)
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refresher)
        self.navName.title = passedInstance
        navigationController?.hidesBarsOnTap = false
        navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (segNum == 1) {
        //Other row is selected - need to deselect it
        if let index = selectedLogIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedLogIndex = indexPath.row
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.performSegueWithIdentifier("ViewAlerts", sender: self)
        }
    }
    
    //   MethName  ObjName    Datatype                                        Has 2 return Int
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segNum == 0) {
            return metricCount
        } else {
            return consoleContent.count
        }
        //return metricCount
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell (style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        //cell.textLabel?.text = "$ZV"
        //cell.detailTextLabel!.font = UIFont(name: "detailFont", size: 11)
        //cell.detailTextLabel?.text = self.zv.text
        
        if (segNum == 0) {
        cell.textLabel?.text = jsonContentKey[indexPath.row]
        cell.detailTextLabel?.text = jsonContent[indexPath.row]
        } else {
            cell.textLabel?.text = consoleContent[indexPath.row]
            cell.detailTextLabel?.text = ">"
            if indexPath.row == selectedLogIndex {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        return cell
    }
    // Segue to AlertController and display the selected Alert
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewAlerts" {
        
            let nav = segue.destinationViewController as! UINavigationController
            let viewLogController = nav.topViewController as! LogController
            //var secondVC: LogController = segue.destinationViewController as! LogController
            viewLogController.passedSession = passedSession
            viewLogController.passedHostIP = passedHostIP
            viewLogController.passedInstance = passedInstance
            viewLogController.passedPort = passedPort
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                selectedLogIndex = indexPath?.row
                if let index = selectedLogIndex {
                    //selectedAlert = alerts[index]
                    
                }
            }
        }
    }
}