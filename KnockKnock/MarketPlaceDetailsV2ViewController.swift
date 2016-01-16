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


class MarketPlaceDetailsV2ViewController: UIViewController {
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet weak var lb_hostName: UILabel!
    @IBOutlet weak var lb_hostContact: UILabel!
    @IBOutlet weak var lb_startDate: UILabel!
    @IBOutlet weak var lb_endDate: UILabel!
    @IBOutlet weak var image_image: PFImageView!
    @IBOutlet weak var table_activity: UITableView!
    
    var pubObj = PFObject(className: "MarketPlace")
    var itiObj = PFObject(className: "Itinerary")
    var hostObj = PFUser()
    
    var activities = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        activities = itiObj["activities"] as! NSArray
        
        activities = activities.sortedArrayUsingDescriptors([
            NSSortDescriptor(key: "day", ascending: true)
            ])
        
        
        lb_price.text = "$ " + String(pubObj["price"] as! Int) + " / pax"
        
        lb_title.text = itiObj["title"] as! String
        
        lb_hostName.text = (hostObj["fName"] as! String) + " " + (hostObj["lName"] as! String)
        
        lb_hostContact.text = String(hostObj["contact"] as! Int)
        
        lb_startDate.text = KnockKnockUtils.dateToString(pubObj["startAvailability"] as! NSDate)
        
        lb_endDate.text = KnockKnockUtils.dateToString(pubObj["lastAvailability"] as! NSDate)
        
        var image = itiObj["image"] as! PFFile
        
        image_image.file = image
        image_image.loadInBackground()
        
        table_activity.delegate = self
        table_activity.dataSource = self
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
    
}