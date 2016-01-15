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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "MarketPlace")
        
        query.whereKey("isPublished", equalTo: true)
        query.whereKey("host", notEqualTo: PFUser.currentUser()!)
        
        query.includeKey("itinerary")
        query.includeKey("host")
        
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


}
