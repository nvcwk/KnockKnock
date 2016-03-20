//
//  PubTableViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 30/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import DZNEmptyDataSet

class PubTableViewController: PFQueryTableViewController {
    
    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        
        self.tableView.reloadEmptyDataSet()
        self.tableView.reloadData()
        
        self.objectsPerPage = 1000
        
        
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil

        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "PubTableViewCell", bundle: nil), forCellReuseIdentifier: "PubViewCell")
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadEmptyDataSet()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    

    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "MarketPlace")
        
        query.includeKey("itinerary")
        query.includeKey("host")
        query.includeKey("itinerary.activities")
        query.includeKey("itinerary.images")
        
        query.whereKey("host", equalTo: PFUser.currentUser()!)
        query.whereKey("isPublished", equalTo: true)
        
        query.addDescendingOrder("updatedAt")
        
        return query
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: PubTableViewCell = tableView.dequeueReusableCellWithIdentifier("PubViewCell") as! PubTableViewCell
        
        if let publish = object{
            
            let itinerary = publish["itinerary"] as! PFObject
            cell.lb_price.text = "$" + String(publish["price"] as! Int)
            
            let startAvailability = KnockKnockUtils.dateToStringDisplay(publish["startAvailability"] as! NSDate)
            let lastAvailability = KnockKnockUtils.dateToStringDisplay(publish["lastAvailability"] as! NSDate)
            
            cell.lb_start.text = startAvailability
            
            cell.lb_end.text = lastAvailability
            
            cell.lb_title.text = itinerary["title"] as! String
            
            //            let imageFile = itinerary["image"] as! PFFile
            
            if(itinerary["images"] != nil) {
                var images = itinerary["images"] as! NSArray
                
                if(images.count > 0) {
                    let imageObj = images[0] as! PFObject
                    
                    let imageFile = imageObj["image"] as! PFFile
                    
                    cell.image_background.file = imageFile
                    cell.image_background.loadInBackground()
                }
            } else {
                if(itinerary["image"] != nil) {
                    let imageFile = itinerary["image"] as! PFFile
                    
                    cell.image_background.file = imageFile
                    cell.image_background.loadInBackground()
                }
            }
        }
        
        return cell
    }
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController : PubDetailsViewController = UIStoryboard(name: "Itinerary", bundle: nil).instantiateViewControllerWithIdentifier("pubDetailsView") as! PubDetailsViewController
        
        viewController.pubObj = objectAtIndexPath(indexPath)! as PFObject
        
        parentNaviController.showViewController(viewController, sender: nil)
        self.tableView.reloadEmptyDataSet()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Published Itinerary"
    }
}

extension PubTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        
        var image = UIImage(named: "empty")!
        
        return image
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "No Itinearies Published Yet!"
        var attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "Publish an itinerary on the 'Created' Tab to Start! "
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
    
    func emptyDataSetShouldAllowImageViewAnimate(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView) -> Bool {
        return true
    }
}
