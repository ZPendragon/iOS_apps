//
//  ViewController.swift
//  JSON Playground
//
//  Created by Kevin Zeckser on 7/20/15.
//  Copyright (c) 2015 Kevin Zeckser. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

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
    
    @IBAction func getData(sender: AnyObject) {
        
        //let urlPath = "http://kzeckser.local:57773/csp/user/Static.JSONPage.cls"
        //IP Address from my Mac: 172.16.144.62
        
        let urlPath = "http://kzeckser.iscinternal.com/csp/mobile/Pulse.Content.cls"
        
        let url = NSURL(string: urlPath)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            var state = ""
            
            if (error != nil) {
                print(error)
            } else {
                
                // With the data object from our HTTP GET request above, we can transform the machine code data into a JSON Object and set the results into a dictionary.
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                // 7/30 Added Table count and reload Table Data
                self.metricCount = jsonResult.count
               
                self.navName.title = (jsonResult.objectForKey("instanceName") as? String)
                //self.zv.text = (jsonResult.objectForKey("clientZV") as? String)
                
                var stateNum = (jsonResult.objectForKey("systemState") as? String)
                
                let json = JSON(jsonResult)
                //println(json.dictionaryValue)
                
                for (index, subJson): (String, JSON) in json {
                    // println(index)
                    // println(subJson)
                    
                    self.keyList = index
                    self.list = subJson.string!
                    
                    //println(self.keyList)
                    //println(self.list)
                    
                    self.jsonContentKey.append(self.keyList)
                    self.jsonContent.append(self.list)
                    
                    //println(self.jsonContentKey)
                    //println(self.jsonContent)
                }

                if (stateNum != nil) {
                    
                    if (stateNum == "-1") {
                        
                       let state = "Hung"
                       self.systemState.text = state
                        
                    } else if (stateNum == "0") {
                        
                       let state = "OK"
                       self.systemState.text = state
                    } else if (stateNum == "1") {
                        
                       let state = "Warning"
                       self.systemState.text = state
                    } else if (stateNum == "2") {
                        
                        let state = "Alert"
                        self.systemState.text = state
                    }
                    }
                self.table.reloadData()
                self.refresher.endRefreshing()
            }
            
        })
        
        task.resume()
        
    }
    
    func refresh() {
        print("Refreshed")
        let urlPath = "http://kzeckser.iscinternal.com/csp/mobile/Pulse.Content.cls"
        
        let url = NSURL(string: urlPath)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            var state = ""
            
            if (error != nil) {
                print(error)
            } else {
                
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.metricCount = jsonResult.count
                self.navName.title = (jsonResult.objectForKey("instanceName") as? String)
                var stateNum = (jsonResult.objectForKey("systemState") as? String)
                let json = JSON(jsonResult)
                for (index, subJson): (String, JSON) in json {
                    
                    self.keyList = index
                    self.list = subJson.string!
                    
                    self.jsonContentKey.append(self.keyList)
                    self.jsonContent.append(self.list)
                }
                
                if (stateNum != nil) {
                    
                    if (stateNum == "-1") {
                        
                        let state = "Hung"
                        self.systemState.text = state
                        
                    } else if (stateNum == "0") {
                        
                        let state = "OK"
                        self.systemState.text = state
                    } else if (stateNum == "1") {
                        
                        let state = "Warning"
                        self.systemState.text = state
                    } else if (stateNum == "2") {
                        
                        let state = "Alert"
                        self.systemState.text = state
                    }
                }
                self.table.reloadData()
                self.refresher.endRefreshing()
            }
            
        })
        
        task.resume()

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refresher)
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //   MethName  ObjName    Datatype                                        Has 2 return Int
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return metricCount
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell (style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        //cell.textLabel?.text = "$ZV"
        //cell.detailTextLabel!.font = UIFont(name: "detailFont", size: 11)
        //cell.detailTextLabel?.text = self.zv.text
        
        cell.textLabel?.text = jsonContentKey[indexPath.row]
        cell.detailTextLabel?.text = jsonContent[indexPath.row]
        return cell
    }
    
    

    
    
    
}

