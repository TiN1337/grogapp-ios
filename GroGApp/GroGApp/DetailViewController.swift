//
//  DetailViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/26/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var displayNameLabel:UILabel!
    @IBOutlet var userNameLabel:UILabel!
    @IBOutlet var avaView:UIImageView!
    @IBOutlet var statusesLabel:UILabel!
    @IBOutlet var bioLabel:UILabel!
    @IBOutlet var locLabel:UILabel!
    
    @IBOutlet var blockButton:UIButton!
    
    @IBOutlet var contentLabel:UITextView!
    @IBOutlet var groupLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    @IBOutlet var imgDetailIndicator:UIButton!
    
    var statusId = -1
    var username = ""
    
    var blocked:Bool = false
    
    var status:JSON!
    var profile:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func blockUnblock() {
        if (blocked) {
            blockButton.setTitle("Block", forState: UIControlState.Normal)
            blockButton.setTitle("Block", forState: UIControlState.Selected)
            var defaults = NSUserDefaults.standardUserDefaults()
            var lUsername = defaults.valueForKey("username") as! String
            var password = defaults.valueForKey("password") as! String
            DataMethods.Unblock(lUsername, password, username)
        } else {
            blockButton.setTitle("Unblock", forState: UIControlState.Normal)
            blockButton.setTitle("Unblock", forState: UIControlState.Selected)
            var defaults = NSUserDefaults.standardUserDefaults()
            var lUsername = defaults.valueForKey("username") as! String
            var password = defaults.valueForKey("password") as! String
            DataMethods.Block(lUsername, password, username)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var lUsername = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        
        status = DataMethods.GetStatus(lUsername, password, statusId)
        profile = DataMethods.GetProfile(username)
        
        blocked = DataMethods.GetBlocked(lUsername, password, username)
        
        if (blocked) {
            blockButton.setTitle("Unblock", forState: UIControlState.Normal)
            blockButton.setTitle("Unblock", forState: UIControlState.Selected)
        } else {
            blockButton.setTitle("Block", forState: UIControlState.Normal)
            blockButton.setTitle("Block", forState: UIControlState.Selected)
        }
        
        displayNameLabel.text = profile["displayname"].stringValue
        userNameLabel.text = "@" + profile["username"].stringValue
        
        if (profile["avaurl"].stringValue != "") {
            var avaUrl = NSURL(string:profile["avaurl"].stringValue)
            if let avUrl = avaUrl {
                var avaData = NSData(contentsOfURL: avUrl)
                var img = UIImage(data: avaData!)!
                
                avaView.image = UIImage(data: avaData!)
                avaView.layer.cornerRadius = avaView.frame.size.width / 2
                avaView.clipsToBounds = true
        }
        }
        
        bioLabel.text = profile["bio"].stringValue
        locLabel.text = profile["location"].stringValue
        statusesLabel.text = profile["statusid"].stringValue
        
        contentLabel.text = status["content"].stringValue
        
        groupLabel.text = "posted to: " + status["group"].stringValue
        dateLabel.text = status["time"].stringValue
        
        // debug
        println(status)
        println(profile)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "iDetail") {
                var dest = segue.destinationViewController as! ImageDetailTableViewController
                dest.status = contentLabel.text!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
