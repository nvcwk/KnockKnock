//
//  MarketplaceHostReviewViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 14/3/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import DZNEmptyDataSet

class MarketplaceHostReviewViewController: PFQueryTableViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var hostObject : PFObject!
    override func viewDidLoad() {
         //print("test here")
        //print(hostObject)
        self.tableView.estimatedRowHeight = 10
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        self.title = hostObject["fName"] as! String + "'s reviews"
        
        self.tableView.reloadData()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        self.objectsPerPage = 1000
        
        super.viewDidLoad()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    // MARK: - Table view data source
    
    override func queryForTable() -> PFQuery {
        
        let query1 = PFQuery(className: "Review")
        query1.whereKey("ClientReview", equalTo: false)
        query1.whereKey("Client", equalTo: hostObject)
        
        let query2 = PFQuery(className: "Review")
        query2.whereKey("ClientReview", equalTo: true)
        query2.whereKey("Host", equalTo: hostObject)
        
        let query = PFQuery.orQueryWithSubqueries([query1, query2])
        
        //query.whereKey("Host", equalTo: hostObject)
        //query.whereKey("ClientReview", equalTo: true)
        query.includeKey("Host")
        query.includeKey("Client")
        query.orderByAscending("Stars")
        return query
        
        
         
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell: MarketplaceHostReviewCell = tableView.dequeueReusableCellWithIdentifier("MarketplaceHostReviewCell") as! MarketplaceHostReviewCell
        if let review = object{
            var reviewer = review["Client"] as! PFObject
            cell.stars.value = review["Stars"] as! CGFloat
            cell.reviwer.text = reviewer["fName"] as! String
            cell.textView.text = review["Review"] as! String
            let reviewDate = review.createdAt
            cell.date.text = KnockKnockUtils.dateToStringDisplay(reviewDate!)
            if(review["ClientReview"] as! Bool == true){
                cell.role.text = "As Local Expert"
            }else{
                cell.role.text = "As Participant"
            }
            
            
            let contentSize = cell.textView.sizeThatFits(cell.textView.bounds.size)
            var frame = cell.textView.frame
            frame.size.height = contentSize.height
            cell.textView.frame = frame
            
            
            let aspectRatioTextViewConstraint = NSLayoutConstraint(item: cell.textView, attribute: .Height, relatedBy: .Equal, toItem: cell.textView, attribute: .Width, multiplier: cell.textView.bounds.height/cell.textView.bounds.width, constant: 1)
            cell.textView.addConstraint(aspectRatioTextViewConstraint)
            
            
            
            
            cell.textView.scrollEnabled = false
            
            var img_profile = reviewer["profilePic"] as! PFFile
            
            cell.profile_image.file = img_profile
            cell.profile_image.loadInBackground()
            
            
            cell.profile_image.layer.cornerRadius = cell.profile_image.frame.size.width/2
            cell.profile_image.clipsToBounds = true
            
            //self.tableView.rowHeight = UITableViewAutomaticDimension
            
            
            
            
        }
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage {
        
        var image = UIImage(named: "empty")!
        
        return image
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "No Reviews Yet!"
        var attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        var text: String = "This tour has no reviews yet! Be the first to review it by booking it!"
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
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
}

