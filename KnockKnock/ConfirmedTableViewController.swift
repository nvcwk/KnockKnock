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

class ConfirmedTableViewController: PFQueryTableViewController {

    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "ConfirmedTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmedViewCell")
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Confirmed")
        
        query.includeKey("Marketplace")
        query.includeKey("Itinerary")
        
        query.whereKey("host", equalTo: PFUser.currentUser()!)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: ConfirmedTableViewCell = tableView.dequeueReusableCellWithIdentifier("ConfirmedTableViewCell") as! ConfirmedTableViewCell
        
        if let confirmed = object{
            let marketplace = confirmed["Marketplace"] as! PFObject
            let itinerary = marketplace["itinerary"] as! PFObject
            cell.header.text = itinerary["titile"] as! String
            
            cell.date.text = "test"
            
            let requester = confirmed["Requester"] as! PFObject
            cell.requester.text = requester.objectForKey("fName") as! String
            
            
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 163.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       /* let viewController : PubDetailsViewController = UIStoryboard(name: "Itinerary", bundle: nil).instantiateViewControllerWithIdentifier("pubDetailsView") as! PubDetailsViewController
        
        viewController.pubObj = objectAtIndexPath(indexPath)! as PFObject
        
        parentNaviController.showViewController(viewController, sender: nil)
*/
    }

}
