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

class ConfirmedTableViewController: PFQueryTableViewController{
    
    
    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        
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
        query.orderByAscending("Date")
        return query
        
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
            }else{
                cell.requester.text = host.objectForKey("fName") as! String
            }
            cell.status.text = pending["Status"]as! String
            
        }
        
        return cell
    }
    

    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController : ConfirmedExpandedViewController = UIStoryboard(name: "Booking", bundle: nil).instantiateViewControllerWithIdentifier("ConfirmedExpandedViewController") as! ConfirmedExpandedViewController
        
        viewController.confirmedObject = objectAtIndexPath(indexPath)! as PFObject
        
        
        parentNaviController.showViewController(viewController, sender: nil)
        self.tableView.reloadEmptyDataSet()

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Confirmed Excursion"
    }
    
}

extension ConfirmedTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        
        var image = UIImage(named: "empty")!
        
        return image
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "No Confirmed Bookings Yet!"
        var attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "Confirmed Bookings  will appear here when confirmation for a tour is made! "
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