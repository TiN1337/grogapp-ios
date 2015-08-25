//
//  MentionsTableViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/20/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    @IBOutlet var statusesView:UITableView!
    
    var statuses = [JSON]()
    
    var avatars = [UIImage]() // let's not reload avatars a billion times...
    var avatarUrls = [String]()
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        refreshStatusList()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mdetail") {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var dest = segue.destinationViewController as! DetailViewController
                dest.statusId = self.statuses[indexPath.row]["id"].int!
                dest.username = self.statuses[indexPath.row]["username"].stringValue
                
            }
        }
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
        return statuses.count
    }
    
    func refreshStatusList() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        
        var resp:JSON;
        
        resp = DataMethods.GetMentions(username, password)
        
        // min += 5
        
        var tempStatuses:JSON? = resp["statuses"]
        
        statuses.removeAll(keepCapacity: false)
        
        // add each of these to tempStatuses
        if (tempStatuses != nil)
        {
            for (index: String, subJson: JSON) in tempStatuses! {
                statuses.append(subJson);
                println(subJson);
            }
        }
        
        
        statusesView.reloadData()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MentionsTableViewCell
        
        println("Is this even getting called? 0_o")
        
        // Configure the cell...
        cell.authorLabel.text = statuses[indexPath.row]["author"].string
        cell.dateLabel.text = statuses[indexPath.row]["time"].string
        cell.contentLabel.text = statuses[indexPath.row]["content"].string
        
        // get the avatar
        if (statuses[indexPath.row]["authoravatar"].string != nil)
        {
            if (statuses[indexPath.row]["authoravatar"].string! != "") {
                if (contains(avatarUrls, statuses[indexPath.row]["authoravatar"].string!)) {
                    var index = find(avatarUrls, statuses[indexPath.row]["authoravatar"].string!)!
                    cell.avatarView.image = avatars[index]
                }
                else {
                    avatarUrls.append(statuses[indexPath.row]["authoravatar"].string!)
                    var avaUrl = NSURL(string:statuses[indexPath.row]["authoravatar"].string!)
                    if let avUrl = avaUrl {
                        var avaData = NSData(contentsOfURL: avUrl)
                        var img = UIImage(data: avaData!)!
                        avatars.append(img)
                        
                        cell.avatarView.image = UIImage(data: avaData!)
                    }
                }
        }
        
            
            
        }
        else {
            cell.avatarView.image = nil
        }
        
        cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.width / 2
        cell.avatarView.clipsToBounds = true
        
        return cell

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
