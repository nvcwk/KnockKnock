//
//  PendingTableViewViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 14/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PendingTableViewViewController: PFQueryTableViewController {

    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingViewCell")
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "MarketPlace")
        
        query.includeKey("itinerary")
        
        query.whereKey("host", equalTo: PFUser.currentUser()!)
        query.whereKey("isPublished", equalTo: true)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: PubTableViewCell = tableView.dequeueReusableCellWithIdentifier("PubViewCell") as! PubTableViewCell
        
        if let publish = object{
            
            let itinerary = publish["itinerary"] as! PFObject
            cell.lb_price.text = String(publish["price"] as! Int)
            
            let startAvailability = KnockKnockUtils.dateToString(publish["startAvailability"] as! NSDate)
            let lastAvailability = KnockKnockUtils.dateToString(publish["lastAvailability"] as! NSDate)
            
            cell.lb_availability.text = startAvailability + " ~ " + lastAvailability
            
            cell.lb_title.text = itinerary["title"] as! String
            
            let imageFile = itinerary["image"] as! PFFile
            
            cell.image_background.file = imageFile
            cell.image_background.loadInBackground()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 163.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController : PubDetailsViewController = UIStoryboard(name: "Itinerary", bundle: nil).instantiateViewControllerWithIdentifier("pubDetailsView") as! PubDetailsViewController
        
        viewController.pubObj = objectAtIndexPath(indexPath)! as PFObject
        
        parentNaviController.showViewController(viewController, sender: nil)
    }
}
