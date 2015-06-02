//
//  AboutViewController.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/28/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var textView:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("viewDidLoad() called")
        let path = NSBundle.mainBundle().pathForResource("credits", ofType: "txt")
        var aboutText = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        println(aboutText)
        textView.text = aboutText as! String
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
