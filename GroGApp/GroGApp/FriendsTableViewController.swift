//
//  FriendsTableViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 4/2/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    var friends = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriends()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadFriends() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")
        let password = defaults.stringForKey("password")
        var resp = DataMethods.GetFriends(username!, password!)["users"]
        
        for (index:String, subJson:JSON) in resp {
            friends.append(subJson.stringValue)
        }
        
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
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GroupsTableViewCell
        
        // Configure the cell...
        cell.groupName.text = friends[indexPath.row]
        
        return cell
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
        if editingStyle == .Delete {
            var defaults = NSUserDefaults.standardUserDefaults()
            var username = defaults.valueForKey("username") as! String
            var password = defaults.valueForKey("password") as! String
            var result = DataMethods.DeleteFriend(username, password, friends[indexPath.row])
            friends.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            if (result) {
                var prompt = UIAlertController(title: "Success", message: "Friend deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                prompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(prompt, animated: true, completion: nil)
            }
            else {
                var prompt = UIAlertController(title: "Failure", message: "Friend not deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                prompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(prompt, animated: true, completion: nil)
            }
        }
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
