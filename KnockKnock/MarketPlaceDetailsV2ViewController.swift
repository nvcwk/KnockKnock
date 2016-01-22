//
//  MarketPlaceDetailsV2ViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 16/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import autoAutoLayout

class MarketPlaceDetailsV2ViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
    
        activities = itiObj["activities"] as! NSArray
        
        activities = activities.sortedArrayUsingDescriptors([
            NSSortDescriptor(key: "day", ascending: true)
            ])
        
        
        lb_price.text = "$ " + String(pubObj["price"] as! Int) + " / pax"
        
        lb_title.text = itiObj["title"] as! String
        
        lb_hostName.text = (hostObj["fName"] as! String) + " " + (hostObj["lName"] as! String)
        
        lb_hostContact.text = String(hostObj["contact"] as! Int)
        
        lb_startDate.text = KnockKnockUtils.dateToStringDisplay(pubObj["startAvailability"] as! NSDate)
        
        lb_endDate.text = KnockKnockUtils.dateToStringDisplay(pubObj["lastAvailability"] as! NSDate)
        
        var image = itiObj["image"] as! PFFile
        
        tour_summary.text = itiObj["summary"] as! String
        
        var img_profile = hostObj["profilePic"] as! PFFile
        img_host.file = img_profile
        img_host.loadInBackground()
        
        image_image.file = image
        image_image.loadInBackground()
        
        table_activity.delegate = self
        table_activity.dataSource = self
        
        self.img_host.layer.cornerRadius = self.img_host.frame.size.width/2
        self.img_host.clipsToBounds = true
        
        self.title = itiObj["title"] as! String
    }
    

}

extension MarketPlaceDetailsV2ViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityDetailsTableViewCell
        
        let activity = activities[indexPath.row] as! PFObject
        
        let day = activity["day"] as! Int
        let title = activity["title"] as! String
        
        cell.lb_day.text = "Day " + String(day) + " - " + title
        cell.tv_details.text = activity["description"] as! String
        
        
        return cell
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