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

class PubDetailsViewController: UIViewController {
    
    @IBOutlet weak var image_background: PFImageView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_start: UILabel!
    @IBOutlet weak var lb_last: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    
    var pubObj = PFObject(className: "MarketPlace")
    
    var itineraryObj = PFObject(className: "Itinerary")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itineraryObj = pubObj["itinerary"] as! PFObject
        
        lb_title.text = itineraryObj["title"] as! String
        
        image_background.file = itineraryObj["image"] as! PFFile
        image_background.loadInBackground()
        
        lb_price.text = "Price: $" + String(pubObj["price"] as! Int)
        
        lb_start.text = "Start Availability: " + KnockKnockUtils.dateToString(
            pubObj["startAvailability"] as! NSDate)
        
        lb_last.text = "Last Availability: " + KnockKnockUtils.dateToString(
            pubObj["lastAvailability"] as! NSDate)
        

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
                    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                    
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
