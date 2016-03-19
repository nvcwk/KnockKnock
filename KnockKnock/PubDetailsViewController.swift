//
//  PubDetailsViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 1/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftSpinner
import autoAutoLayout
import ImageSlideshow

class PubDetailsViewController: UIViewController {
    
    @IBOutlet weak var image_background: PFImageView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_start: UILabel!
    @IBOutlet weak var lb_last: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet weak var image_host: ProfileAvatar!
    @IBOutlet weak var lb_hostName: UILabel!
    @IBOutlet weak var table_activities: UITableView!
    @IBOutlet weak var tv_summary: UITextView!
    @IBOutlet weak var slideshow_images: ImageSlideshow!
    
    var pubObj = PFObject(className: "MarketPlace")
    
    var itineraryObj = PFObject(className: "Itinerary")
    
    var hostObj = PFUser()
    
    var activities = NSArray()
    
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.image_host.layer.cornerRadius = self.image_host.frame.size.width/2
        self.image_host.clipsToBounds = true
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        itineraryObj = pubObj["itinerary"] as! PFObject
        
        activities = itineraryObj["activities"] as! NSArray
        
        activities = activities.sortedArrayUsingDescriptors([
            NSSortDescriptor(key: "day", ascending: true)
            ])
        
        hostObj = pubObj["host"] as! PFUser
        
        lb_title.text = itineraryObj["title"] as! String
        //
        //        image_background.file = itineraryObj["image"] as! PFFile
        //        image_background.loadInBackground()
        
        lb_price.text = String(pubObj["price"] as! Int)
        
        lb_start.text =  KnockKnockUtils.dateToStringDisplay(pubObj["startAvailability"] as! NSDate)
        
        lb_last.text = KnockKnockUtils.dateToStringDisplay(pubObj["lastAvailability"] as! NSDate)
        
        lb_hostName.text = (hostObj["fName"] as! String) //+ " " + (hostObj["lName"] as! String)
        
        if (hostObj["profilePic"] != nil) {
            var img_profile = hostObj["profilePic"] as! PFFile
            image_host.file = img_profile
            image_host.loadInBackground()
        }
        
        tv_summary.text = itineraryObj["summary"] as! String
        
        table_activities.delegate = self
        table_activities.dataSource = self
        
        var imageArr = [AFURLSource]()
        
        if (itineraryObj["images"] != nil) {
            var images = itineraryObj["images"] as! NSArray
            
            if(images.count > 0) {
                for var i = 0; i < images.count; i++ {
                    let imageObj = images[i] as! PFObject
                    
                    let image = imageObj["image"] as! PFFile
                    
                    imageArr.append(AFURLSource(urlString: image.url!)!)
                }
            }
        } else {
            if(itineraryObj["image"] != nil) {
                var image = itineraryObj["image"] as! PFFile
                
                imageArr.append(AFURLSource(urlString: image.url!)!)
            }
        }
        
        slideshow_images.clipsToBounds = true
        slideshow_images.contentScaleMode = UIViewContentMode.ScaleAspectFill
        slideshow_images.setImageInputs(imageArr)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "openFullScreen")
        slideshow_images.addGestureRecognizer(gestureRecognizer)
    }
    
    
    func openFullScreen() {
        let ctr = FullScreenSlideshowViewController()
        // called when full-screen VC dismissed and used to set the page to our original slideshow
        ctr.pageSelected = {(page: Int) in
            self.slideshow_images.setScrollViewPage(page, animated: false)
        }
        
        // set the initial page
        ctr.initialPage = slideshow_images.scrollViewPage
        // set the inputs
        ctr.inputs = slideshow_images.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: slideshow_images);
        ctr.transitioningDelegate = self.transitionDelegate!
        self.presentViewController(ctr, animated: true, completion: nil)
    }
    
    
    
    @IBAction func actionMore(sender: AnyObject) {
        
        
        let alert:UIAlertController = UIAlertController(title: "More", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.performSegueWithIdentifier("toEditPublishView", sender: self)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.actionPubDelete()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func actionPubDelete() {
        let alertController = UIAlertController(title: "Delete Publishing??", message: "Are you sure??", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: { UIAlertAction in
            SwiftSpinner.show("Deleting...")
            self.pubObj["isPublished"] = false
            self.pubObj.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                SwiftSpinner.hide()
                
                if(error == nil) {
                    NSNotificationCenter.defaultCenter().postNotificationName("loadPublish", object: nil)
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)

                }
            })
            }
        )
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        alertController.addAction(CancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue .identifier == "toItiView") {
            let controller = segue.destinationViewController as! ItiDetailsViewController
            
            controller.itineraryObj = itineraryObj
        } else  if (segue.identifier == "toEditPublishView") {
            let controller = segue.destinationViewController as! PubDetailsEditViewController
            controller.publishObj = pubObj
        }
    }
    
}

extension PubDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityDetailsTableViewCell
        
        let activity = activities[indexPath.row] as! PFObject
        
        let day = activity["day"] as! Int
        let title = activity["title"] as! String
        
        cell.lb_day.text = "Day " + String(day) + " - " + title
        cell.tv_details.text = activity["description"] as! String
        
        
        return cell
    }
    
    
}
