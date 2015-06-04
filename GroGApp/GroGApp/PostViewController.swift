//
//  PostViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 2/25/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var groups = [JSON]()

    @IBOutlet var postContent:UITextView!
    
    @IBAction func uploadLibraryImage() {
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = false
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let toUpload:UIImage = image
        var iData = UIImagePNGRepresentation(toUpload)
        var url = SwiftImgur.uploadImage(iData)
        postContent.text = postContent.text + url
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadCameraImage() {
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func postAndGo() {
        // post
        var contentString = postContent.text!
        if count(contentString) > 200 {
            var countWarning = UIAlertController(title: "Character Limit Exceeded", message: "Your post must be less than 200 characters.", preferredStyle: UIAlertControllerStyle.Alert)
            countWarning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(countWarning, animated:true, completion: nil)
        }
        else {
            /* var defaults = NSUserDefaults.standardUserDefaults()
            var username = defaults.valueForKey("username") as String
            var password = defaults.valueForKey("password") as String
            
            DataMethods.PostStatus(username, password, contentString, 1)
            
            // go
            performSegueWithIdentifier("unwindToHomeScreen", sender: self) */
            var defaults = NSUserDefaults.standardUserDefaults()
            var username = defaults.valueForKey("username") as! String
            var password = defaults.valueForKey("password") as! String
            var prompt = UIAlertController(title: "Group", message: "Which group should this be posted to?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            prompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            prompt.addAction(UIAlertAction(title: "Public", style: UIAlertActionStyle.Default, handler: {(alertAction:UIAlertAction!) in
                DataMethods.PostStatus(username, password, contentString, 1)
                self.performSegueWithIdentifier("unwindToHomeScreen", sender: self)
            }))
            prompt.addAction(UIAlertAction(title: "Friends", style: UIAlertActionStyle.Default, handler: {(alertAction:UIAlertAction!) in
                DataMethods.PostStatus(username, password, contentString, 0)
                self.performSegueWithIdentifier("unwindToHomeScreen", sender: self)
            }))
            for j in groups {
                prompt.addAction(UIAlertAction(title: j["name"].stringValue, style: UIAlertActionStyle.Default, handler: {(alertAction:UIAlertAction!) in
                    DataMethods.PostStatus(username, password, contentString, j["id"].intValue)
                    self.performSegueWithIdentifier("unwindToHomeScreen", sender: self)
                }))
            }
            self.presentViewController(prompt, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var defaults = NSUserDefaults.standardUserDefaults()
        var username = defaults.valueForKey("username") as! String
        var password = defaults.valueForKey("password") as! String
        var resp = DataMethods.GetGroups(username, password)["groups"]
        for (index: String, subJson: JSON) in resp {
            groups.append(subJson)
        }
    }
    
    @IBAction func unwindToPostScreen(segue:UIStoryboardSegue) {
        
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
