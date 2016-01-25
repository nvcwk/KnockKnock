//
//  RatingViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 25/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import autoAutoLayout
class RatingViewController: UIViewController {

    var confirmedObject : PFObject!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reviewTitle: UILabel!
       override func viewDidLoad() {
        //setting up textbox
        textView.layer.borderColor =  UIColor.blackColor().CGColor
        textView.layer.backgroundColor =  UIColor.lightGrayColor().CGColor
        
        let hostObject = confirmedObject["Host"] as! PFObject
    
        if (hostObject == PFUser.currentUser()){
        //host reviews requester
        reviewTitle.text = "Review your participants!"
        }else{
        //requester reviews host
         reviewTitle.text = "Review your host!"
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        var comments = textView.text
        
        if ( comments.characters.count < 10){
            var alertTitle = "WE NEED TO HEAR MORE!"
            var message = String("Please enter a minimum of 10 characters")
            let okText = "Okay"
            
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButtton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButtton)
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    

}
