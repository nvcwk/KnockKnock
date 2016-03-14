//
//  ConfirmedExpandedViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 15/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import autoAutoLayout

class ConfirmedExpandedViewController: UIViewController {
    @IBOutlet weak var confirmNum: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var requester: UILabel!
    @IBOutlet weak var requesterLabel: UILabel!
    @IBOutlet weak var requesterContact: UILabel!
    @IBOutlet weak var pax: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var confirmCompletion: UIButton!
    
    
    var confirmedObject : PFObject!
    var requesterObject : PFObject!
    var hostObject : PFObject!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        self.view!.removeConstraints(self.view.constraints)
        
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        image.image? = (image.image?.imageWithRenderingMode(.AlwaysTemplate))!
        image.tintColor = UIColor(red:0.14, green:0.63, blue:0.78, alpha:1.0)
        //image.tintColor = UIColor.greenColor()
        
        
        confirmNum.text = confirmedObject.objectId
        hostObject = (confirmedObject["Host"]) as! PFObject
        requesterObject = (confirmedObject["Requester"]) as! PFObject
        let itineraryObject = (confirmedObject["Itinerary"]) as! PFObject
        var caseStatus =  confirmedObject["Status"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        var start = confirmedObject["Date"] as! NSDate
        var end = start.add(days: (itineraryObject["duration"] as! Int) - 1)
        
        
        header.text = itineraryObject["title"] as! String
        pax.text = String(confirmedObject["Pax"])
        
        startDate.text = KnockKnockUtils.dateToStringDisplay(start)
        endDate.text = KnockKnockUtils.dateToStringDisplay(end)
        
        value.text = String(confirmedObject["Total"])
        status.text = caseStatus
        
        //default to hide fields and button
        reviewButton.hidden = true
        remarksLabel.text = ""
        remarks.text = ""
        confirmCompletion.hidden = true
        
        if (hostObject == PFUser.currentUser()){
            requesterLabel.text = "Requested By: "
            requester.text = requesterObject["fName"] as! String
            requesterContact.text = String(requesterObject["email"])
            
            
        }else{
            requesterLabel.text = "Your Local Expert: "
            requester.text = hostObject["fName"] as! String
            requesterContact.text = String(hostObject["email"])
            
        }
        
        if (confirmedObject["Status"] as! String == "Cancelled"){
            cancelButton.setTitle("", forState: UIControlState.Normal)
            cancelButton.enabled = false
            cancelButton.hidden = true
            image.image = UIImage(named: "cancel")
            image.image? = (image.image?.imageWithRenderingMode(.AlwaysTemplate))!
            image.tintColor = UIColor.redColor()
            
            //theImageView.tintColor = UIColor(red:0.14, green:0.63, blue:0.78, alpha:1.0)
            
            remarks.text = confirmedObject["Remarks"] as! String
            remarksLabel.text = "Remarks: "
            status.font = UIFont.boldSystemFontOfSize(18.0)
            status.textColor = UIColor.redColor()
        }else if(confirmedObject["Status"] as! String == "Pending Completion"){
            cancelButton.setTitle("", forState: UIControlState.Normal)
            cancelButton.enabled = false
            cancelButton.hidden = true
            if(hostObject == PFUser.currentUser()){
                confirmCompletion.enabled = true
                confirmCompletion.hidden = false
                
            }else{
            
            }
            
        }else if(confirmedObject["Status"] as! String == "Completed"){
            remarks.text = confirmedObject["Remarks"] as! String
            remarksLabel.text = "Remarks: "
            cancelButton.setTitle("", forState: UIControlState.Normal)
            cancelButton.enabled = false
            cancelButton.hidden = true
            
            if(hostObject == PFUser.currentUser()){
                if (confirmedObject["HostReviewed"] == nil || confirmedObject["HostReviewed"] as! Bool == false){
                    
                    reviewButton.enabled = true
                    reviewButton.hidden = false
                }else{
                    reviewButton.enabled = false
                    reviewButton.hidden = false
                    reviewButton.setTitle("Tour Reviewed", forState: UIControlState.Normal)
                }
            }else{
                if (confirmedObject["ClientReviewed"] == nil || confirmedObject["ClientReviewed"] as! Bool == false){
                    
                    reviewButton.enabled = true
                    reviewButton.hidden = false
                }else{
                    reviewButton.enabled = false
                    reviewButton.hidden = false
                    reviewButton.setTitle("Tour Reviewed", forState: UIControlState.Normal)
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        
        let bookAlert = UIAlertController(title: "Cancel Booking", message: "Confirm?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.confirmedObject["Status"] = "Cancelled"
            let hostObject = (self.confirmedObject["Host"]) as! PFObject
            if (hostObject == PFUser.currentUser()){
                self.confirmedObject["Remarks"] = "Host Cancelled"
                
                var hostName = self.hostObject["fName"] as! String
                
                PFCloud.callFunctionInBackground("hostCancelConfirm", withParameters: ["hoster": hostName, "requester": self.requesterObject.objectId!])
                
                
            }else{
                self.confirmedObject["Remarks"] = "Requester Cancelled"
                
                var requesterName = self.requesterObject["fName"] as! String
                
                PFCloud.callFunctionInBackground("requesterCancelConfirm", withParameters: ["hoster": self.hostObject.objectId!, "requester": requesterName])
                

            }
            let myAlert =
            UIAlertController(title:"Updating", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            //remove all booked dates from marketplace bookedDate array
            var firstDate = self.confirmedObject["Date"] as! NSDate
            var marketplaceObject = self.confirmedObject["Marketplace"]
            var bookedDateArray = marketplaceObject["bookedDate"] as! [NSDate]
            
            let itineraryObject = (self.confirmedObject["Itinerary"]) as! PFObject
            var duration = itineraryObject["duration"] as! Int
            for (var i = 0; i < duration; i++){
                var tempDate = firstDate.add(days: i)
                var index = bookedDateArray.indexOf(tempDate)
                if (index != nil){
                    bookedDateArray.removeAtIndex(index!)
                }
            }
            var marketPlace = PFObject(className: "MarketPlace")
            
            marketPlace = self.confirmedObject["Marketplace"] as! PFObject
            
            marketPlace["bookedDate"] = bookedDateArray
            
            marketPlace.saveInBackground()
            //
            self.confirmedObject.saveInBackgroundWithBlock {
                (success : Bool?, error: NSError?) -> Void in
                if (success != nil) {
                    let myAlert =
                    UIAlertController(title:"Done!!", message: "", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("loadConfirm", object: nil)
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                    self.presentViewController(myAlert, animated:true, completion:nil);
                } else {
                    NSLog("%@", error!)
                }
            }
        }))
        bookAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        
        presentViewController(bookAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        
        let itineraryObject = (confirmedObject["Itinerary"]) as! PFObject
        
        let activities = itineraryObject["activities"] as! NSArray
        print(activities)
        var storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("itiDetailsView") as! ItiDetailsViewController
        
        controller.itineraryObj = itineraryObject
        self.showViewController(controller, sender:self)
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?) {
        var DestViewController : RatingViewController = segue.destinationViewController as! RatingViewController
        DestViewController.confirmedObject = confirmedObject as PFObject
    }
    
    
    
    @IBAction func confirmCompletionButtonTapped(sender: AnyObject) {
        
        let bookAlert = UIAlertController(title: "Tour Completed?", message: "Confirm?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.confirmedObject["Status"] = "Completed"
            self.confirmedObject["Remarks"] = "Tour Completed"

            let myAlert =
            UIAlertController(title:"Updating", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            //
            self.confirmedObject.saveInBackgroundWithBlock {
                (success : Bool?, error: NSError?) -> Void in
                if (success != nil) {
                    let myAlert =
                    UIAlertController(title:"Done!!", message: "", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("loadConfirm", object: nil)
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                    self.presentViewController(myAlert, animated:true, completion:nil);
                } else {
                    NSLog("%@", error!)
                }
            }
        }))
        bookAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        
        presentViewController(bookAlert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
}

