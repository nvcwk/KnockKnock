//
//  ConfirmedExpandedViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 15/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse

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

    var confirmedObject : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmNum.text = confirmedObject.objectId
        let hostObject = (confirmedObject["Host"]) as! PFObject
        let requesterObject = (confirmedObject["Requester"]) as! PFObject
        let itineraryObject = (confirmedObject["Itinerary"]) as! PFObject
        var caseStatus =  confirmedObject["Status"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        var start = confirmedObject["Date"] as! NSDate
        var end = start.add(days: itineraryObject["duration"] as! Int)
        
        header.text = itineraryObject["title"] as! String
        pax.text = String(confirmedObject["Pax"])
        startDate.text = dateFormatter.stringFromDate(start)
        endDate.text = dateFormatter.stringFromDate(end)
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
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

   }
