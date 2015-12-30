//
//  ItiTableViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 30/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class ItiTableViewController: PFQueryTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "ItiTableViewCell", bundle: nil), forCellReuseIdentifier: "ItiTableViewCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Itinerary")
        query.whereKey("host", equalTo: PFUser.currentUser()!)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: ItiTableViewCell = tableView.dequeueReusableCellWithIdentifier("ItiTableViewCell") as! ItiTableViewCell
        
        if let itinerary = object{

            cell.lb_title.text = itinerary["title"] as! String
            
            let date = itinerary.createdAt!
            
            cell.lb_created.text = KnockKnockUtils.dateToString(date)
            
            let imageFile = itinerary["image"] as! PFFile
            
            cell.image_background.file = imageFile
            cell.image_background.loadInBackground()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 163.0
    }
    
    
}
