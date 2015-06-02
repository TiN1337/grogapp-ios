//
//  GroupMembershipTableViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/27/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class GroupMembershipTableViewController: UITableViewController {
    
    var users:JSON = []
    var id = -1
    
    @IBAction func addMember() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        
        var prompt = UIAlertController(title: "Add User", message: "Enter the name of the user to add.", preferredStyle: UIAlertControllerStyle.Alert)
        prompt.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Username"
            textField.secureTextEntry = false})
        prompt.addAction((UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)))
        prompt.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {(alertAction: UIAlertAction!) in
            let text = prompt.textFields![0] as! UITextField
            var success = DataMethods.AddUserToGroup(username, password, self.id, text.text)
            if (success) {
                var newPrompt = UIAlertController(title: "Success", message: "User added.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: {self.reloadGroup(true)})
            }
            else {
                var newPrompt = UIAlertController(title: "Failure", message: "Failed to add user to group.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: nil)
            }
        }))
        self.presentViewController(prompt, animated: true, completion: nil)
    }
    
    func reloadGroup(reloadTable:Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        var groups = DataMethods.GetGroups(username, password)
        var groupSet = groups["groups"]
        for (index: String, subJson: JSON) in groupSet {
            if (subJson["id"].intValue == id) {
                users = subJson["users"]
            }
        }
        if (reloadTable) {
            tableView.reloadData()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GroupsTableViewCell

        // Configure the cell...
        cell.groupName.text = users[indexPath.row].stringValue

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
            // Delete the row from the data source
            var defaults = NSUserDefaults.standardUserDefaults()
            var username = defaults.valueForKey("username") as! String
            var password = defaults.valueForKey("password") as! String
            var result = DataMethods.DeleteUserFromGroup(username, password, id, users[indexPath.row].stringValue)
            reloadGroup(false)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            if (result) {
                var prompt = UIAlertController(title: "Success", message: "Group member removed.", preferredStyle: UIAlertControllerStyle.Alert)
                prompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(prompt, animated: true, completion: nil)
            }
            else {
                var prompt = UIAlertController(title: "Failure", message: "Group member not removed.", preferredStyle: UIAlertControllerStyle.Alert)
                prompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(prompt, animated: true, completion: nil)
            }
            // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
