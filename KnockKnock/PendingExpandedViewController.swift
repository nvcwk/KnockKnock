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
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        pendingNum.text = pendingObject.objectId
        let hostObject = (pendingObject["Host"]) as! PFObject
        let requesterObject = (pendingObject["Requester"]) as! PFObject
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

            if (caseStatus == "Rejected"){
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
    


}
