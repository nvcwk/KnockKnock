//
//  RatingViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 25/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import SwiftSpinner
import Parse
import autoAutoLayout
import HCSStarRatingView

class RatingViewController: UIViewController {

    var confirmedObject : PFObject!
    var clientRating = 0.0
    var hostRating = 0.0
    var clientRatingCount = 1.0
    var hostRatingCount = 1.0
    
    
    @IBOutlet weak var stars: HCSStarRatingView!
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
        }else{
            var rating = stars.value
            var ToBeUpdated = PFObject(className: "ToBeUpdated")
            let clientObject = confirmedObject["Requester"] as! PFObject
            let hostObject = confirmedObject["Host"] as! PFObject
            
            if (hostObject == PFUser.currentUser()){
                
                if( clientObject["rating"] != nil){
                    self.clientRating = clientObject["rating"] as! Double
                }
                if( clientObject["ratingCount"] != nil){
                    self.clientRatingCount = clientObject["ratingCount"] as! Double
                    self.clientRatingCount = self.clientRatingCount + 1
                }
                self.clientRating = (self.clientRating + Double(rating))
            }else{
                if( hostObject["rating"] != nil){
                    hostRating = hostObject["rating"] as! Double
                }
                if( hostObject["ratingCount"] != nil){
                    self.hostRatingCount = hostObject["ratingCount"] as! Double
                }
                self.hostRatingCount = self.hostRatingCount + 1
                self.hostRating = (self.hostRating + Double(rating))
            }
                ToBeUpdated["RatingCount"] = self.clientRatingCount
                ToBeUpdated["Rating"] =  self.clientRating
                confirmedObject["Reviewed"] = true
                confirmedObject.saveInBackground()
                SwiftSpinner.show("Submitting...")
                ToBeUpdated.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    SwiftSpinner.hide()
                    
                    if (success) {
                        KnockKnockUtils.okAlert(self, title: "Submitted!", message: "Thank You", handle: { UIAlertAction in
                            NSNotificationCenter.defaultCenter().postNotificationName("setupProfileTxtFields", object: nil)
                            
                            self.navigationController?.popToRootViewControllerAnimated(false)
                            
                            
                            }
                        )
                    } else {
                        KnockKnockUtils.okAlert(self, title: "Error!", message: (error?.userInfo["error"])! as! String, handle: nil)
                    }
                }
                
                
            

            
            var booking = PFObject(className: "Reviews")

        }
        
    }
    
    

}
