//
//  MarketPlaceV2TableViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 15/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MarketPlaceV2TableViewController: PFQueryTableViewController {
    
    var published = true
    
    override func viewDidLoad() {
        let test = KnockKnockUtils.dateToString(NSDate())
        
        print(KnockKnockUtils.dateToParse(test))
        
        print("TEST")
        super.viewDidLoad()
        
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "MarketPlace")
        
        if (PFUser.currentUser() != nil) {
            query.whereKey("isPublished", equalTo: published)
            query.whereKey("host", notEqualTo: PFUser.currentUser()!)
            
            query.includeKey("itinerary")
            query.includeKey("host")
            query.includeKey("itinerary.activities")
        }
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("marketplaceCell") as! MarketPlaceV2TableViewCell
        
        if let mpObj = object {
            
            let itiObj = mpObj["itinerary"] as! PFObject
            
            cell.lb_title.text = itiObj["title"] as! String
            
            cell.lb_price.text = String(mpObj["price"] as! Int)
            
            let image = itiObj["image"] as! PFFile
            
            cell.image_background.file = image
            cell.image_background.loadInBackground()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 163.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toMarketPlaceDetail") {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
    
                let controller = segue.destinationViewController as! MarketPlaceDetailsV2ViewController
                
                let pubObj = objectAtIndexPath(indexPath)
                
                let itiObj = pubObj!["itinerary"] as! PFObject
                
                let hostObj = pubObj!["host"] as! PFUser
                
                controller.pubObj = pubObj!
                controller.itiObj = itiObj
                controller.hostObj = hostObj
    
            }
            
        }
    }
    
    
    
}
