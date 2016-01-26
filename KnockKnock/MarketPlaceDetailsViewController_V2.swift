//
//  MarketPlaceDetailsViewController_V2.swift
//  KnockKnock
//
//  Created by Koh Siu Wei Brenda on 26/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import autoAutoLayout

class MarketPlaceDetailsViewController_V2: UITableViewController {
    

    @IBOutlet weak var con_timeline: UIView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet weak var lb_hostName: UILabel!
    @IBOutlet weak var lb_hostContact: UILabel!
    @IBOutlet weak var lb_startDate: UILabel!
    @IBOutlet weak var lb_endDate: UILabel!
    @IBOutlet weak var image_image: PFImageView!
    @IBOutlet weak var table_activity: UITableView!
    @IBOutlet weak var img_host: PFImageView!
    @IBOutlet weak var tour_summary: UITextView!
    
    var pubObj = PFObject(className: "MarketPlace")
    var itiObj = PFObject(className: "Itinerary")
    var hostObj = PFUser()
    
    var activities = NSArray()
    var timeLine : TimelineView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        activities = itiObj["activities"] as! NSArray
        
        activities = activities.sortedArrayUsingDescriptors([
            NSSortDescriptor(key: "day", ascending: true)
            ])
        
        var frames: [TimeFrame] = []
        
        for var i = 0; i < activities.count; ++i {
            var insert_into : TimeFrame
            print(i)
            let activity = activities[i] as! PFObject as PFObject!
            
            let day = activity["day"] as! Int
            var day_string = "Day" + String(day)
            let title = activity["title"] as! String
            
            insert_into = TimeFrame(text: title, date: day_string, image: nil)
            
            frames.append(insert_into)
        }
        
        timeLine = TimelineView(bulletType: .Circle, timeFrames: frames)
        
        con_timeline.addSubview(timeLine)
        
        con_timeline.addConstraints([
            NSLayoutConstraint(item: timeLine, attribute: .Left, relatedBy: .Equal, toItem: con_timeline, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeLine, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: con_timeline, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeLine, attribute: .Top, relatedBy: .Equal, toItem: con_timeline, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeLine, attribute: .Right, relatedBy: .Equal, toItem: con_timeline, attribute: .Right, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: timeLine, attribute: .Width, relatedBy: .Equal, toItem: con_timeline, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
        
        
        
        lb_price.text = "$ " + String(pubObj["price"] as! Int) + " / pax"
        
        lb_title.text = itiObj["title"] as! String
        
        lb_hostName.text = (hostObj["fName"] as! String)
        
        lb_startDate.text = KnockKnockUtils.dateToStringDisplay(pubObj["startAvailability"] as! NSDate)
        
        lb_endDate.text = KnockKnockUtils.dateToStringDisplay(pubObj["lastAvailability"] as! NSDate)
        
        var image = itiObj["image"] as! PFFile
        
        tour_summary.text = itiObj["summary"] as! String
        
        var img_profile = hostObj["profilePic"] as! PFFile
        img_host.file = img_profile
        img_host.loadInBackground()
        
        image_image.file = image
        image_image.loadInBackground()

        
        self.img_host.layer.cornerRadius = self.img_host.frame.size.width/2
        self.img_host.clipsToBounds = true
        
        self.title = itiObj["title"] as! String

    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestViewController : BookingViewController = segue.destinationViewController as! BookingViewController
        if (pubObj["bookedDate"] != nil){
            var bookedDatesArray = pubObj["bookedDate"] as! [NSDate]
            DestViewController.bookedDatesArray = bookedDatesArray
            
        }
        DestViewController.StartDate = pubObj["startAvailability"] as! NSDate
        DestViewController.EndDate = pubObj["lastAvailability"] as! NSDate
        DestViewController.price = pubObj["price"] as! Int
        DestViewController.host = hostObj
        DestViewController.marketplace = pubObj
        DestViewController.itinerary = itiObj
        DestViewController.numOfDays = itiObj["duration"] as! Int
    }
    
}
