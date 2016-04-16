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
import DZNEmptyDataSet

class CancelledTableViewController: PFQueryTableViewController{
    
    
    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        self.objectsPerPage = 1000
        
        self.tableView.reloadData()
        
        //        self.tableView.emptyDataSetSource = nil
        //        self.tableView.emptyDataSetDelegate = nil
        
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
    //        self.tableView.emptyDataSetSource = nil
    //        self.tableView.emptyDataSetDelegate = nil
    //    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        
        let query1 = PFQuery(className: "Pending")
        query1.whereKey("Requester", equalTo: PFUser.currentUser()!)
        query1.whereKey("Status", containedIn: ["Rejected", "Expired", "Cancelled"])
        
        let query2 = PFQuery(className: "Pending")
        query2.whereKey("Host", equalTo: PFUser.currentUser()!)
        query2.whereKey("Status", containedIn: ["Rejected", "Expired", "Cancelled"])
        
        var query3 = PFQuery(className: "Confirmed")
        query3.whereKey("Requester", equalTo: PFUser.currentUser()!)
        query3.whereKey("Status", equalTo: "Cancelled")
        
        var query4 = PFQuery(className: "Confirmed")
        query4.whereKey("Host", equalTo: PFUser.currentUser()!)
        query4.whereKey("Status", equalTo: "Cancelled")
        
        var query = PFQuery.orQueryWithSubqueries([query1, query2])
        query.includeKey("Marketplace")
        query.includeKey("Itinerary")
        query.includeKey("Host")
        query.includeKey("Requester")
        query.includeKey("Itinerary.activities")
        query.orderByAscending("Date")
        
        var query5 = PFQuery.orQueryWithSubqueries([query3, query4])
        query5.includeKey("Marketplace")
        query5.includeKey("Itinerary")
        query5.includeKey("Host")
        query5.includeKey("Requester")
        query5.includeKey("Itinerary.activities")
        query5.addAscendingOrder("Status")
        query5.addDescendingOrder("Date")
    
        return query5
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: PendingTableViewCell = tableView.dequeueReusableCellWithIdentifier("PendingTableViewCell") as! PendingTableViewCell
        
        
        if let pending = object{
            
            var date = pending["Date"]! as! NSDate
            //check if booking has been completed
            if (date < KnockKnockUtils.utcStringToLocal(KnockKnockUtils.dateToStringGMT(NSDate()))){
                let statusForUpdate = pending["Status"] as! String
                if(statusForUpdate == "Completed"){
                    
                }else{
                    pending["Status"] = "Pending Completion"
                    pending["Remarks"] = ""
                    pending.saveInBackground()
                    self.tableView.reloadEmptyDataSet()
                    
                }
                
            }
            
            let marketplace = pending["Marketplace"] as! PFObject
            let itinerary = pending["Itinerary"] as! PFObject
            cell.header.text = itinerary["title"] as! String
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "GMT")
            
            cell.date.text = KnockKnockUtils.dateToStringDisplay(date)
            
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
//        let viewController : ConfirmedExpandedViewController = UIStoryboard(name: "Booking", bundle: nil).instantiateViewControllerWithIdentifier("ConfirmedExpandedViewController") as! ConfirmedExpandedViewController
//        
//        viewController.confirmedObject = objectAtIndexPath(indexPath)! as PFObject
//        
//        
//        parentNaviController.showViewController(viewController, sender: nil)
//        self.tableView.reloadEmptyDataSet()
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cancelled Excursion"
    }
    
}

extension CancelledTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        
        var image = UIImage(named: "empty")!
        
        return image
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "No Cancelled Bookings!"
        var attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "Cancalled Bookings  will appear here! "
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