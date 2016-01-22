//
//  ConfirmedTableViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 14/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import autoAutoLayout

class ConfirmedTableViewController: PFQueryTableViewController {

    
    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
    
    self.tableView.registerNib(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingTableViewCell")
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
    
    var query1 = PFQuery(className: "Confirmed")
    query1.whereKey("Requester", equalTo: PFUser.currentUser()!)
    
    
    var query2 = PFQuery(className: "Confirmed")
    query2.whereKey("Host", equalTo: PFUser.currentUser()!)
    
    
    
    var query = PFQuery.orQueryWithSubqueries([query1, query2])
    query.includeKey("Marketplace")
    query.includeKey("Itinerary")
    query.includeKey("Host")
    query.includeKey("Requester")
    query.includeKey("Itinerary.activities")
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
        let host = pending["Host"] as! PFObject
        
        if (host == PFUser.currentUser()){
            cell.requester.text = requester.objectForKey("fName") as! String
        }else{
            cell.requester.text = host.objectForKey("fName") as! String
        }
    
    
    }
    
    return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 69.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let viewController : ConfirmedExpandedViewController = UIStoryboard(name: "Booking", bundle: nil).instantiateViewControllerWithIdentifier("ConfirmedExpandedViewController") as! ConfirmedExpandedViewController
    
    viewController.confirmedObject = objectAtIndexPath(indexPath)! as PFObject
    
    
    parentNaviController.showViewController(viewController, sender: nil)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Confirmed Tours"
    }

}
