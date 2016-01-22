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
    var confirmedObject : PFObject!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        image.image? = (image.image?.imageWithRenderingMode(.AlwaysTemplate))!
        image.tintColor = UIColor(red:0.14, green:0.63, blue:0.78, alpha:1.0)
        //image.tintColor = UIColor.greenColor()
        
        
        confirmNum.text = confirmedObject.objectId
        let hostObject = (confirmedObject["Host"]) as! PFObject
        let requesterObject = (confirmedObject["Requester"]) as! PFObject
        let itineraryObject = (confirmedObject["Itinerary"]) as! PFObject
        var caseStatus =  confirmedObject["Status"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        var start = confirmedObject["Date"] as! NSDate
        var end = start.add(days: (itineraryObject["duration"] as! Int) - 1)
        var stringDate = KnockKnockUtils.dateToString(start)
        var index = stringDate.endIndex.advancedBy(-15)
        
        
        header.text = itineraryObject["title"] as! String
        pax.text = String(confirmedObject["Pax"])
        
        startDate.text = (KnockKnockUtils.dateToString(start)).substringToIndex(index)
        endDate.text = (KnockKnockUtils.dateToString(end)).substringToIndex(index)
        
        value.text = String(confirmedObject["Total"])
        status.text = caseStatus
        
        
        if (hostObject == PFUser.currentUser()){
            requesterLabel.text = "Requested By: "
            requester.text = requesterObject["fName"] as! String
            requesterContact.text = String(requesterObject["contact"])
            
            
        }else{
            requesterLabel.text = "Your Host: "
            requester.text = hostObject["fName"] as! String
            requesterContact.text = String(hostObject["contact"])
            
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
        }
        //cell alignment and font
//        confirmNum.textAlignment = NSTextAlignment.Right;
//        header.textAlignment = NSTextAlignment.Center;
//        header.font = UIFont.boldSystemFontOfSize(20.0)
//        pax.textAlignment = NSTextAlignment.Right;
//        value.textAlignment = NSTextAlignment.Right;
//        status.textAlignment = NSTextAlignment.Right;
//        remarks.textAlignment = NSTextAlignment.Right;
//        startDate.textAlignment = NSTextAlignment.Left;
//        endDate.textAlignment = NSTextAlignment.Right;
//        requester.textAlignment = NSTextAlignment.Right;
//        requesterContact.textAlignment = NSTextAlignment.Right;
//        requester.textAlignment = NSTextAlignment.Right;
//        requesterContact.textAlignment = NSTextAlignment.Right;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        
        let bookAlert = UIAlertController(title: "Cancel Booking", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.confirmedObject["Status"] = "Cancelled"
            let hostObject = (self.confirmedObject["Host"]) as! PFObject
            if (hostObject == PFUser.currentUser()){
                self.confirmedObject["Remarks"] = "Host Cancelled"
             }else{
                self.confirmedObject["Remarks"] = "Requester Cancelled"
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

    @IBAction func browseItineraryButtonTapped(sender: AnyObject) {
        let itineraryObject = (confirmedObject["Itinerary"]) as! PFObject
        
         let activities = itineraryObject["activities"] as! NSArray
        print(activities)
        var storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("itiDetailsView") as! ItiDetailsViewController
        
        controller.itineraryObj = itineraryObject
        self.showViewController(controller, sender:self)
        
    }
    
    
    }

