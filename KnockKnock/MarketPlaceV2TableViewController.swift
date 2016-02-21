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
import autoAutoLayout

class MarketPlaceV2TableViewController: PFQueryTableViewController {
    
    var published = true
    
    var sort = 1
    var ascending = true
    
    var startDate = 1.years.ago()
    var endDate = 5.years.fromNow()
    var days = 5
    var minPrice = 0
    var maxPrice = 999
    
    override func viewDidLoad() {
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        super.viewDidLoad()
        
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "MarketPlace")
        query.includeKey("itinerary")
        query.includeKey("host")
        query.includeKey("itinerary.activities")
        query.includeKey("itinerary.images")
        
        var query2 = PFQuery(className: "Itinerary")
        
        if(PFUser.currentUser() != nil) {
            if(ascending) {
                if (sort == 1) {
                    query.orderByAscending("updatedAt")
                } else if (sort == 2) {
                    query.orderByAscending("price")
                } else if (sort == 3) {
                    query.orderByAscending("startAvailability")
                }
            } else {
                if (sort == 1) {
                    query.orderByDescending("updatedAt")
                } else if (sort == 2) {
                    query.orderByDescending("price")
                } else if (sort == 3) {
                    query.orderByDescending("startAvailability")
                }
            }
            
            query.whereKey("isPublished", equalTo: published)
            query.whereKey("host", notEqualTo: PFUser.currentUser()!)
            query.whereKey("lastAvailability", greaterThanOrEqualTo: NSDate())
            
            query.whereKey("lastAvailability", lessThanOrEqualTo: endDate)
            query.whereKey("startAvailability", greaterThanOrEqualTo: startDate) // needs to double check
            query.whereKey("price", greaterThanOrEqualTo: minPrice)
            query.whereKey("price", lessThanOrEqualTo: maxPrice)
        }
        
        query2.whereKey("duration", lessThanOrEqualTo: days)
        
        query.whereKey("itinerary", matchesQuery: query2)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("marketplaceCell") as! MarketPlaceV2TableViewCell
        
        if let mpObj = object {
            
            if let itiObj = mpObj["itinerary"] as? PFObject {
                
                cell.lb_title.text = itiObj["title"] as! String
                
                cell.lb_price.text = String(mpObj["price"] as! Int) + " SGD"
                
                cell.startDate.text = KnockKnockUtils.dateToStringDisplay( mpObj["startAvailability"] as! NSDate)
                
                
                cell.endDate.text = KnockKnockUtils.dateToStringDisplay( mpObj["lastAvailability"] as! NSDate)
                //                let image = itiObj["image"] as! PFFile
                
                if(itiObj["images"] != nil) {
                    var images = itiObj["images"] as! NSArray
                    
                    if(images.count > 0) {
                        let imageObj = images[0] as! PFObject
                        
                        let imageFile = imageObj["image"] as! PFFile
                        
                        cell.image_background.file = imageFile
                        cell.image_background.loadInBackground()
                    }
                } else {
                    if(itiObj["image"] != nil) {
                        let imageFile = itiObj["image"] as! PFFile
                        
                        cell.image_background.file = imageFile
                        cell.image_background.loadInBackground()
                    }
                }
                
                
                //for stars
                let hostObj = itiObj["host"] as! PFObject
                var rating : Double = 0.0
                var ratingCount = 0.0
                
                let query = PFQuery(className: "Review")
                query.whereKey("Itinerary", equalTo: itiObj)
                query.whereKey("ClientReview", equalTo: true)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil{
                        if let objects = objects as [PFObject]!{
                            for object in objects {
                                if (object["Stars"] != nil){
                                    rating = rating +  Double(object["Stars"] as! Double)
                                    ratingCount = ratingCount + 1
                                }
                                var stars = rating/ratingCount
                                cell.stars.value = CGFloat(stars)
                            }
                        }
                    }else{
                        //log details of the failure
                        print("error: \(error!)  \(error!.userInfo)")
                    }
                }
            }
            
            
        }
        
        return cell
    }
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 308.0
    //    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toMarketPlaceDetail") {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                
                let controller = segue.destinationViewController as! MarketPlaceDetailsViewController_V2
                
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
