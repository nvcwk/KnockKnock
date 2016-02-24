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


    
    
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var stars: HCSStarRatingView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reviewTitle: UILabel!
       override func viewDidLoad() {
        //setting up textbox
        //textView.layer.borderColor =  UIColor.blackColor().CGColor
        //textView.layer.backgroundColor =  UIColor.lightGrayColor().CGColor
        
        
        theImageView.image? = (theImageView.image?.imageWithRenderingMode(.AlwaysTemplate))!
        theImageView.tintColor = UIColor(red:0.07, green:0.55, blue:0.63, alpha:1.0)

        
        let hostObject = confirmedObject["Host"] as! PFObject
        let clientObject = confirmedObject["Requester"] as! PFObject
        
        if (hostObject == PFUser.currentUser()){
        //host reviews requester
        reviewTitle.text = "Tell us what you like about  \(clientObject["fName"])!"
        }else{
        //requester reviews host
         reviewTitle.text = "Tell us what you like about \(hostObject["fName"])!"
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
            var review = PFObject(className: "Review")
            let clientObject = confirmedObject["Requester"] as! PFObject
            let hostObject = confirmedObject["Host"] as! PFObject
            var userToUpdate: PFObject
            
            if (hostObject == PFUser.currentUser()){
                userToUpdate = clientObject
                review["ClientReview"] = false
                confirmedObject["HostReviewed"] = true
            }else{
                userToUpdate = hostObject
                review["ClientReview"] = true
                confirmedObject["ClientReviewed"] = true
            }
        
            //retrieve and update rating table
            let query = PFQuery(className: "Rating")
            query.whereKey("User", equalTo: userToUpdate)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil{
                    var dbrating = 0
                    var dbratingCount = 0
                    if let objects = objects as [PFObject]!{
                        for object in objects {
                            if (object["Rating"] != nil){
                                dbrating = object["Rating"] as! Int
                            }
                            dbrating = dbrating + Int(rating)
                            if (object["RatingCount"] != nil){
                                dbratingCount = object["RatingCount"] as! Int
                            }
                            dbratingCount = dbratingCount + 1
                            object["Rating"] = dbrating
                            object["RatingCount"] = dbratingCount
                            object.saveInBackground()
                        }
                        
                    }
                    if objects?.count == 0{
                        var ratingObject = PFObject(className: "Rating")
                        
                        ratingObject["User"] = userToUpdate
                        ratingObject["Rating"] = dbrating + Int(rating)
                        ratingObject["RatingCount"] = dbratingCount + 1
                        ratingObject.saveInBackground()
                        
                    }
                }else{
                    //log details of the failure
                    print("error: \(error!)  \(error!.userInfo)")
                }
            }

            
            
                confirmedObject.saveInBackground()
                review["Stars"] = rating
                review["Host"] = hostObject
                review["Client"] = clientObject
                review["Itinerary"] = confirmedObject["Itinerary"] as! PFObject
                review["Review"] = textView.text
                SwiftSpinner.show("Submitting...")
                review.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
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
