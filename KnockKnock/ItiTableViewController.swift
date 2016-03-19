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
import DZNEmptyDataSet

class ItiTableViewController: PFQueryTableViewController {
    
    var parentNaviController = UINavigationController()
    
    override func viewDidLoad() {
        
        self.tableView.reloadEmptyDataSet()
        self.tableView.reloadData()
        self.objectsPerPage = 1000
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "ItiTableViewCell", bundle: nil), forCellReuseIdentifier: "ItiTableViewCell")
        super.viewDidLoad()
        
    }
    
    
    deinit {
        
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil

    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Itinerary")
        
        query.includeKey("activities")
        query.includeKey("images")
        
        query.addDescendingOrder("updatedAt")
        query.whereKey("host", equalTo: PFUser.currentUser()!)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell: ItiTableViewCell = tableView.dequeueReusableCellWithIdentifier("ItiTableViewCell") as! ItiTableViewCell
        
        if let itinerary = object {
            
            cell.lb_title.text = itinerary["title"] as! String
            
            let date = itinerary.createdAt!
            
            cell.lb_createdDateTime.text = KnockKnockUtils.dateToString(date)
            
            //let imageFile = itinerary["image"] as! PFFile
            
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
        let viewController : ItiDetailsViewController = UIStoryboard(name: "Itinerary", bundle: nil).instantiateViewControllerWithIdentifier("itiDetailsView") as! ItiDetailsViewController
        
        viewController.itineraryObj = objectAtIndexPath(indexPath)! as PFObject
        
        parentNaviController.showViewController(viewController, sender: nil)
        self.tableView.reloadEmptyDataSet()

        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Created Itinerary"
    }

    
}

extension ItiTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    // code for DZNEmptyDataSet goes here
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        
        var image = UIImage(named: "empty")!
        
        return image
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "No Itinearies Created Yet!"
        var attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "Select the '+' button to start! "
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
    

}
