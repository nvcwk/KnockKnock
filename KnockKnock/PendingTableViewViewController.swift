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
import autoAutoLayout
import DZNEmptyDataSet

class PendingTableViewViewController: PFQueryTableViewController{
    
    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        self.objectsPerPage = 1000
        
        //loadingViewEnabled = false
        
        self.tableView.reloadData()
        //
        //        self.tableView.emptyDataSetSource = nil
        //        self.tableView.emptyDataSetDelegate = nil
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        self.tableView.registerNib(UINib(nibName: "PendingTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingTableViewCell")
        self.tableView.reloadEmptyDataSet()
        
        
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    //    deinit{
    //                self.tableView.emptyDataSetSource = nil
    //                self.tableView.emptyDataSetDelegate = nil
    //    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        
        let query1 = PFQuery(className: "Pending")
        query1.whereKey("Requester", equalTo: PFUser.currentUser()!)
        query1.whereKey("Status", notEqualTo: "Confirmed")
        
        let query2 = PFQuery(className: "Pending")
        query2.whereKey("Host", equalTo: PFUser.currentUser()!)
        query2.whereKey("Status", notEqualTo: "Confirmed")
        
        
        
        let query = PFQuery.orQueryWithSubqueries([query1, query2])
        query.includeKey("Marketplace")
        query.includeKey("Itinerary")
        query.includeKey("Host")
        query.includeKey("Requester")
        query.includeKey("Itinerary.activities")
        query.orderByAscending("Date")
        
        return query
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: PendingTableViewCell = tableView.dequeueReusableCellWithIdentifier("PendingTableViewCell") as! PendingTableViewCell
        
        if let pending = object{
            
            var startDate = pending["Date"]as! NSDate
            if (startDate < KnockKnockUtils.utcStringToLocal(KnockKnockUtils.dateToStringGMT(NSDate())))
            {
                updateRecords(pending)
            }
            let marketplace = pending["Marketplace"] as! PFObject
            let itinerary = pending["Itinerary"] as! PFObject
            cell.header.text = itinerary["title"] as! String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "GMT")
            
            cell.date.text = KnockKnockUtils.dateToStringDisplay(startDate)
            
            let requester = pending["Requester"] as! PFObject
            let host = pending["Host"] as! PFObject
            
            if (host == PFUser.currentUser()){
                cell.requester.text = requester.objectForKey("fName") as! String
                
                if (requester.objectForKey("profilePic") != nil) {
                    
                    cell.image_profile.file = requester.objectForKey("profilePic") as! PFFile
                    
                    cell.image_profile.loadInBackground()
                }
                
                
            } else{
                cell.requester.text = host.objectForKey("fName") as! String
                
                if (host.objectForKey("profilePic") != nil) {
                    
                    
                    cell.image_profile.file = host.objectForKey("profilePic") as! PFFile
                    
                    cell.image_profile.loadInBackground()
                }
            }
            cell.status.text = pending["Status"]as! String
            
            
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 129.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController : PendingExpandedViewController = UIStoryboard(name: "Booking", bundle: nil).instantiateViewControllerWithIdentifier("PendingExpandedViewController") as! PendingExpandedViewController
        
        viewController.pendingObject = objectAtIndexPath(indexPath)! as PFObject
        
        
        parentNaviController.showViewController(viewController, sender: nil)
        self.tableView.reloadEmptyDataSet()
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Requests Pending"
    }
    
    func updateRecords(record: PFObject){
        
        record["Status"] = "Expired"
        record["Remarks"] = "Booking Expired"
        record.saveInBackground()
        
        
    }
}

extension PendingTableViewViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    // code for DZNEmptyDataSet goes here
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        
        var image = UIImage(named: "empty")!
        
        return image
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "No Bookings Yet!"
        var attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "Booking Requests  will appear here when someone books your tour! "
        var paragraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
        //paragraph.lineBreakMode = NSLineBreakByWordWrapping
        paragraph.alignment = .Center
        var attributes = [NSFontAttributeName: UIFont.systemFontOfSize(14.0), NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView) -> Bool {
        return true
    }
}

