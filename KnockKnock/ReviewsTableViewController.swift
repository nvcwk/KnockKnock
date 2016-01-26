//
//  ReviewsTableViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 26/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ReviewsTableViewController: PFQueryTableViewController {
    var itineraryObject : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: - Table view data source

    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "Review")
        query.whereKey("Itinerary", equalTo: itineraryObject)
        query.whereKey("ClientReview", equalTo: true)
        return query
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell: ReviewsTableCell = tableView.dequeueReusableCellWithIdentifier("ReviewsTableCell") as! ReviewsTableCell
        if let review = object{
            var reviewer = review["Client"] as! PFObject
            cell.stars.value = review["Stars"] as! CGFloat
            cell.reviwer.text = reviewer["fName"] as! String
            cell.textView.text = review["Review"] as! String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105.0
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
}
