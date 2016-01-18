//
//  ItiDetailsViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 31/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ItiDetailsViewController: UIViewController {
    var itineraryObj = PFObject(className: "Itinerary")
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var tv_description: UITextView!
    @IBOutlet weak var image_image: PFImageView!
    @IBOutlet weak var tv_activities: UITableView!
    @IBOutlet weak var barBtn_publish: UIBarButtonItem!
    
    var activities = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let host = itineraryObj["host"] as! PFUser
        
        if (PFUser.currentUser() != host) {
            barBtn_publish.title = ""
            barBtn_publish.enabled = false
        }
        
        activities = itineraryObj["activities"] as! NSArray
        
        activities = activities.sortedArrayUsingDescriptors([
            NSSortDescriptor(key: "day", ascending: true)
            ])
    
        lb_title.text = itineraryObj["title"] as! String
        
        image_image.file = itineraryObj["image"] as! PFFile
        image_image.loadInBackground()

        tv_description.text = itineraryObj["summary"] as! String
        
        tv_activities.delegate = self
        tv_activities.dataSource = self
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromItitoPublish") {
            let controller = segue.destinationViewController as! ItiPublishViewController
            
            controller.itineraryObj = itineraryObj
        }
    }
}

extension ItiDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityViewCell", forIndexPath: indexPath) as! ActivityDetailsTableViewCell

        let activity = activities[indexPath.row] as! PFObject

        let day = activity["day"] as! Int
        let title = activity["title"] as! String
        
        cell.lb_day.text = "Day " + String(day) + " - " + title
        cell.tv_details.text = activity["description"] as! String

        
        return cell
    }

}
