//
//  PendingExpandedViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 15/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse

class PendingExpandedViewController: UIViewController {
    @IBOutlet weak var pendingNum: UILabel!
    @IBOutlet weak var requester: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var pax: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButton2: UIButton!
    @IBOutlet weak var requesterContact: UILabel!
    @IBOutlet weak var requesterLabel: UILabel!
    @IBOutlet weak var remarks: UITextField!
    @IBOutlet weak var reason: UILabel!
    
    var pendingObject : PFObject!
    var hostObject : PFObject!
    var requesterObject : PFObject!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        pendingNum.text = pendingObject.objectId
        hostObject = (pendingObject["Host"]) as! PFObject
        requesterObject = (pendingObject["Requester"]) as! PFObject
        let itineraryObject = (pendingObject["Itinerary"]) as! PFObject
        var caseStatus =  pendingObject["Status"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        var start = pendingObject["Date"] as! NSDate
        var end = start.add(days: itineraryObject["duration"] as! Int)
        
        header.text = itineraryObject["title"] as! String
        pax.text = String(pendingObject["Pax"])
        startDate.text = dateFormatter.stringFromDate(start)
        endDate.text = dateFormatter.stringFromDate(end)
        value.text = String(pendingObject["Total"])
        status.text = caseStatus
        
        
        
        
        
        if (hostObject == PFUser.currentUser()){
            requesterLabel.text = "Requested By: "
            requester.text = requesterObject["fName"] as! String
            requesterContact.text = String(requesterObject["contact"])
            actionButton.setTitle("Accept", forState: UIControlState.Normal)
            actionButton2.setTitle("Reject", forState: UIControlState.Normal)

        }else{
            requesterLabel.text = "Your Host: "
            requester.text = hostObject["fName"] as! String
            requesterContact.text = String(hostObject["contact"])
            actionButton.setTitle("", forState: UIControlState.Normal)
            actionButton.enabled = false

            if (caseStatus == "Rejected" || caseStatus == "Cancelled"){
                reason.text = "Reason: "
                remarks.text =  pendingObject["Remarks"] as! String
                actionButton2.setTitle("", forState: UIControlState.Normal)
                actionButton2.enabled = false
            }else{
                reason.text = ""
                actionButton2.setTitle("Cancel", forState: UIControlState.Normal)
            }
            
        }
        
        
        // Do any additional setup "after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button1Tapped(sender: AnyObject) {
            //accept codes
        
        let bookAlert = UIAlertController(title: "Hosting", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            var booking = PFObject(className: "Confirmed")
            booking["Requester"] = self.pendingObject["Requester"]
            booking["Date"] = self.pendingObject["Date"]
            booking["Host"] = self.pendingObject["Host"]
            booking["Pax"] = self.pendingObject["Pax"]
            booking["Total"] = self.pendingObject["Total"]
            booking["Marketplace"] = self.pendingObject["Marketplace"]
            booking["Itinerary"] = self.pendingObject["Itinerary"]
            booking["Status"] = "Confirmed"
            let myAlert =
            UIAlertController(title:"Updating", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            booking.saveInBackgroundWithBlock {
                (success : Bool?, error: NSError?) -> Void in
                if (success != nil) {
                    self.pendingObject.deleteInBackground()
                    
                    let myAlert =
                    UIAlertController(title:"Done!!", message: "", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
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

    @IBAction func button2Tapped(sender: AnyObject) {
        //reject codes
        
        let bookAlert = UIAlertController(title: "Reject/Cancel", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
           // var booking = PFObject(className: "Pending")
            if (self.hostObject == PFUser.currentUser()){
                self.pendingObject["Status"] = "Rejected"
                self.pendingObject["Remarks"] = "Host Rejected"
            }else{
                self.pendingObject["Status"] = "Cancelled"
                self.pendingObject["Remarks"] = "User Cancelled"
            }
            let myAlert =
            UIAlertController(title:"Updating", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            self.pendingObject.saveInBackgroundWithBlock {
                (success : Bool?, error: NSError?) -> Void in
                if (success != nil) {
                let myAlert =
                    UIAlertController(title:"Done!!", message: "", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
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