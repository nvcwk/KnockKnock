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
        
        self.tableView.registerNib(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingTableViewCell")
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
    
        var query1 = PFQuery(className: "Pending")
        query1.whereKey("Requester", equalTo: PFUser.currentUser()!)
        
        
        var query2 = PFQuery(className: "Pending")
        query2.whereKey("Host", equalTo: PFUser.currentUser()!)
       
        
        
        var query = PFQuery.orQueryWithSubqueries([query1, query2])
        query.includeKey("Marketplace")
        query.includeKey("Itinerary")

        
        
        return query
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: PendingTableViewCell = tableView.dequeueReusableCellWithIdentifier("PendingTableViewCell") as! PendingTableViewCell
        
        if let pending = object{
            let marketplace = pending["Marketplace"] as! PFObject
            let itinerary = pending["Itinerary"] as! PFObject
            cell.header.text = itinerary["title"] as! String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "GMT")
            
            cell.date.text = dateFormatter.stringFromDate(pending["Date"]! as! NSDate)
            
            let requester = pending["Requester"] as! PFObject
            cell.requester.text = requester.objectForKey("fName") as! String
            
            
            
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 163.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*let viewController : PubDetailsViewController = UIStoryboard(name: "Itinerary", bundle: nil).instantiateViewControllerWithIdentifier("pubDetailsView") as! PubDetailsViewController
        
        viewController.pubObj = objectAtIndexPath(indexPath)! as PFObject
        
        parentNaviController.showViewController(viewController, sender: nil)*/
    }
}
