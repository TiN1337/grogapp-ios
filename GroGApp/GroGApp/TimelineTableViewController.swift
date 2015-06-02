//
//  TimelineTableViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 2/7/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    @IBOutlet var statusesView:UITableView!
    @IBOutlet var aRefreshControl:UIRefreshControl!
    
    var statuses = [JSON]()
    
    var avatars = [UIImage]() // let's not reload avatars a billion times...
    var avatarUrls = [String]()
    
    var initiallyLoaded = false // keep the costly load timeline operation from happening EVERY time we return to this view
    
    private struct rContainer { static var ready = false }
    
    var highestId = 0;
    var lowestId = 0;
    
    var min = 0;
    
    @IBAction func newFollowFriend() {
        var prompt = UIAlertController(title: "Add User", message: "Enter the username of a user to follow or friend", preferredStyle: UIAlertControllerStyle.Alert)
        prompt.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Username"
            textField.secureTextEntry = false})
        prompt.addAction((UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)))
        prompt.addAction(UIAlertAction(title: "Unfollow", style: UIAlertActionStyle.Destructive, handler: {(alertAction: UIAlertAction!) in
            let defaults = NSUserDefaults.standardUserDefaults()
            let username = defaults.stringForKey("username")
            let password = defaults.stringForKey("password")
            let text = prompt.textFields![0] as! UITextField
            var success = DataMethods.UnfollowUser(username!, password!, text.text)
            if (success) {
                var newPrompt = UIAlertController(title: "Success", message: "User unfollowed.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: nil)
            }
            else {
                var newPrompt = UIAlertController(title: "Unfollow Failed", message: "User does not exist, or you do not follow them.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: nil)
            }
        }))
        prompt.addAction(UIAlertAction(title: "Follow", style: UIAlertActionStyle.Default, handler: {(alertAction: UIAlertAction!) in
            let defaults = NSUserDefaults.standardUserDefaults()
            let username = defaults.stringForKey("username")
            let password = defaults.stringForKey("password")
            let text = prompt.textFields![0] as! UITextField
            var success = DataMethods.FollowUser(username!, password!, text.text)
            if (success) {
                var newPrompt = UIAlertController(title: "Success", message: "User followed.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: nil)
            }
            else {
                var newPrompt = UIAlertController(title: "Follow Failed", message: "User does not exist.", preferredStyle: UIAlertControllerStyle.Alert)
                newPrompt.addAction((UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)))
                self.presentViewController(newPrompt, animated: true, completion: nil)
            }
        }))
        prompt.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Default, handler: {
            (alertAction: UIAlertAction!) in
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue("", forKey: "username")
            defaults.setValue("", forKey: "password")
            var successPrompt = UIAlertController(title: "Success", message: "You are now logged out.", preferredStyle: UIAlertControllerStyle.Alert)
            successPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                (alertAction: UIAlertAction!) in
                self.promptUserForCredentials(false)
            }))
            self.presentViewController(successPrompt, animated: true, completion: nil)
        }))
        self.presentViewController(prompt, animated: true, completion: nil)
    }
    
    @IBAction func refresh(sender:UIRefreshControl) {
        println("Pulled to refresh!")
        updateStatusView()
        aRefreshControl.endRefreshing()
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func updateStatusView() {
        refreshStatusList(false)
        statusesView.reloadData()
    }
    
    func getReady() {
        rContainer.ready = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detail") {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var dest = segue.destinationViewController as! DetailViewController
                dest.statusId = self.statuses[indexPath.row]["id"].int!
                dest.username = self.statuses[indexPath.row]["username"].stringValue
                
            }
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y + scrollView.frame.size.height
        if (offset > scrollView.contentSize.height) {
            println("Something should be happening!")
                println("This shouldn't be seen more often than every five seconds! 😭")
                rContainer.ready = false;
                refreshStatusList(true)
                statusesView.reloadData()
                // var timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector(getReady()), userInfo: nil, repeats: false);
            
        }
    }
    
    /* override func scrollViewDidScroll(scrollView: UIScrollView) {
        // println("Scroll view did scroll!")
        var offset = scrollView.contentOffset.y + scrollView.frame.size.height
        if (offset > scrollView.contentSize.height + 50) {
            println("Something should be happening!")
            if (rContainer.ready) {
                println("This shouldn't be seen more often than every five seconds! 😭")
                rContainer.ready = false;
                refreshStatusList(true)
                statusesView.reloadData()
                var timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector(getReady()), userInfo: nil, repeats: false);
            }
        }
        // println(offset)
        // println(scrollView.contentSize.height)
    } */

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //DataMethods.ValidateUser("justin", "123change")
        
        
        // making things a little more responsive
        if (initiallyLoaded) {
            return
        }
        else {
            initiallyLoaded = true
        }
        
        // check if user info stored in phone already
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")
        let password = defaults.stringForKey("password")
        
        if (username != nil && password != nil) {
            // validate against the server
            let userIsValid = DataMethods.ValidateUser(username!, password!)
            
            if (userIsValid) {
                // populate the timeline
                updateStatusView()
            }
            else {
                // invalid credentials are stored; get new ones
                promptUserForCredentials(false)
            }
        }
        else {
            // no credentials are stored; get some
            promptUserForCredentials(false)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // recursive calls happen when a prompt fails to get valid credentials
    // these give a different message to the user
    func promptUserForCredentials(recursive:Bool) {
        // how to do this prompt
        // http://stackoverflow.com/questions/24579537/how-do-you-use-an-alert-to-prompt-for-text-in-ios-with-swift
        
        // initial username/password prompt
        var credentialPrompt = UIAlertController(title: "Log In", message: recursive ? "Incorrect username or password" : "Enter your username and password", preferredStyle: UIAlertControllerStyle.Alert)
        credentialPrompt.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Username"
            textField.secureTextEntry = false})
        credentialPrompt.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true})
        credentialPrompt.addAction(UIAlertAction(title: "Create/Reset", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction!) in
            var otherPrompt = UIAlertController(title: "Account Options", message: "Create a new account or reset a forgotten password", preferredStyle: UIAlertControllerStyle.Alert)
            otherPrompt.addAction(UIAlertAction(title: "Create Account", style: UIAlertActionStyle.Default, handler: {(alertAction:UIAlertAction!) in
                self.createAccountPrompt(false)
            }))
            otherPrompt.addAction(UIAlertAction(title: "Request Password Reset Code", style: UIAlertActionStyle.Default, handler: {(alertAction:UIAlertAction!) in
                
            }))
            otherPrompt.addAction(UIAlertAction(title: "Enter Password Reset Code", style: UIAlertActionStyle.Default, handler: {(alertAction:UIAlertAction!) in
                
            }))
            otherPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
                (alertAction:UIAlertAction!) in
                self.promptUserForCredentials(false)
            }))
            self.presentViewController(otherPrompt, animated: true, completion: nil)
        }))
        credentialPrompt.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction:UIAlertAction!) in
            let uField = credentialPrompt.textFields![0] as! UITextField
            let pField = credentialPrompt.textFields![1] as! UITextField
            // validate these against the server
            let userIsValid = DataMethods.ValidateUser(uField.text, pField.text)
            if (userIsValid) {
                var defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(uField.text, forKey: "username")
                defaults.setValue(pField.text, forKey: "password")
                var successPrompt = UIAlertController(title: "Login Successful", message: "You are now logged in.", preferredStyle: UIAlertControllerStyle.Alert)
                successPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(successPrompt, animated: true, completion: nil)
            }
            else {
                self.promptUserForCredentials(true)
            }
        }))
        
        self.presentViewController(credentialPrompt, animated: true, completion: nil) // should probably have timeline loading stuff in another function that can be called after this
    }
    
    func createAccountPrompt(recursive:Bool) {
        var accPrompt = UIAlertController(title: "Create Account", message: "Enter a username, email address, and password", preferredStyle: UIAlertControllerStyle.Alert)
        accPrompt.addTextFieldWithConfigurationHandler({
            (textField:UITextField!) in
            textField.placeholder = "Username"
            textField.secureTextEntry = false
        })
        accPrompt.addTextFieldWithConfigurationHandler({
            (textField:UITextField!) in
            textField.placeholder = "Email"
            textField.secureTextEntry = false
        })
        accPrompt.addTextFieldWithConfigurationHandler({
            (textField:UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        accPrompt.addTextFieldWithConfigurationHandler({
            (textField:UITextField!) in
            textField.placeholder = "Confirm Password"
            textField.secureTextEntry = true
        })
        accPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (alertAction:UIAlertAction!) in
            let uField = accPrompt.textFields![0] as! UITextField
            let eField = accPrompt.textFields![1] as! UITextField
            let pField = accPrompt.textFields![2] as! UITextField
            let cField = accPrompt.textFields![3] as! UITextField
            if (pField.text != cField.text) {
                var passPrompt = UIAlertController(title: "Passwords must match", message: "Make sure both password fields match", preferredStyle: UIAlertControllerStyle.Alert)
                passPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                    (action:UIAlertAction!) in
                    self.createAccountPrompt(false)
                }))
                self.presentViewController(passPrompt, animated: true, completion: nil)
            }
        }))
        accPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alertAction:UIAlertAction!) in
            self.promptUserForCredentials(false)
        }))
        self.presentViewController(accPrompt, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshStatusList(moreOld:Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        
        var resp:JSON;
        
        if (!moreOld) {
            resp = DataMethods.GetTimeline(username, password, 0, 4)
        }
        else {
            resp = DataMethods.GetTimeline(username, password, min, min + 4)
        }
        
        min += 5
        
        var tempStatuses:JSON = resp["statuses"]
        
        // add each of these to tempStatuses
        for (index: String, subJson: JSON) in tempStatuses {
            if (subJson["id"].int < lowestId || lowestId == 0) {
                println("lowestId is \(lowestId)")
                lowestId = subJson["id"].int!
                if (subJson["id"].int > highestId) {
                    highestId = subJson["id"].int!
                }
                statuses.append(subJson)
            }
            else if (subJson["id"].int > highestId || highestId == 0) {
                println(subJson["id"])
                println(highestId)
                highestId = subJson["id"].int!
                statuses.insert(subJson, atIndex: 0)
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
        // Return the number of rows in the section.
        return statuses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StatusTableViewCell

        // println("Is this even getting called? 0_o")
        
        // Configure the cell...
        cell.authorLabel.text = statuses[indexPath.row]["author"].string
        cell.dateLabel.text = statuses[indexPath.row]["time"].string
        cell.contentLabel.text = statuses[indexPath.row]["content"].string
        cell.contentLabel.sizeToFit()
        
        // get the avatar
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