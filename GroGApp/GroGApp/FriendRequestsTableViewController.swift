//
//  FriendRequestsTableViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/27/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class FriendRequestsTableViewController: UITableViewController {
    
    var reqs = [String]()
    
    func loadFriendRequests() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")
        let password = defaults.stringForKey("password")
        var resp = DataMethods.GetFriendRequests(username!, password!)["users"]
        
        for (index:String, subJson:JSON) in resp {
            reqs.append(subJson.stringValue)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendRequests()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reqs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GroupsTableViewCell

        // Configure the cell...
        cell.groupName.text = reqs[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var denyOption = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Deny", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            let username = defaults.stringForKey("username")
            let password = defaults.stringForKey("password")
            DataMethods.DenyFriendRequest(username!, password!, self.reqs[indexPath.row])
            self.loadFriendRequests()
            tableView.reloadData()
        })
        var acceptOption = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Accept", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            let username = defaults.stringForKey("username")
            let password = defaults.stringForKey("password")
            DataMethods.AcceptFriendRequest(username!, password!, self.reqs[indexPath.row])
            self.loadFriendRequests()
            tableView.reloadData()
        })
        return [denyOption, acceptOption]
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        /* if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
