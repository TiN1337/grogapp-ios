//
//  GroupsTableTableViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/27/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class GroupsTableTableViewController: UITableViewController {
    
    var groups = [JSON]()
    
    @IBAction func AddGroup() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        
        var prompt = UIAlertController(title: "New Group", message: "Enter the name of the new group", preferredStyle: UIAlertControllerStyle.Alert)
        prompt.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false})
        prompt.addAction((UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)))
        prompt.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: {(alertAction: UIAlertAction!) in
            let text = prompt.textFields![0] as! UITextField
            var success = DataMethods.CreateGroup(username, password, text.text)
            if (success) {
                var newPrompt = UIAlertController(title: "Success", message: "Group created.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: {self.reloadGroups()})
            }
            else {
                var newPrompt = UIAlertController(title: "Failure", message: "Group creation failed.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: nil)
            }
        }))
        self.presentViewController(prompt, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gdetail") {
            var dest = segue.destinationViewController as! GroupMembershipTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                dest.users = groups[indexPath.row]["users"]
                dest.id = groups[indexPath.row]["id"].intValue
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadGroups()
        tableView.reloadData()
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
        return groups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GroupsTableViewCell

        cell.groupName.text = groups[indexPath.row]["name"].stringValue

        return cell
    }
    
    func reloadGroups() {
        groups.removeAll(keepCapacity: false)
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        var resp = DataMethods.GetGroups(username, password)
        var tempGroups = resp["groups"]
        for (index: String, subJson: JSON) in tempGroups {
            groups.append(subJson)
        }
        
        tableView.reloadData()
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
            var result = DataMethods.DeleteGroup(username, password, groups[indexPath.row]["id"].intValue)
            groups.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            if (result) {
                var prompt = UIAlertController(title: "Success", message: "Group deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                prompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(prompt, animated: true, completion: nil)
            }
            else {
                var prompt = UIAlertController(title: "Failure", message: "Group not deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                prompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(prompt, animated: true, completion: nil)
            }
            // reloadGroups()
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
