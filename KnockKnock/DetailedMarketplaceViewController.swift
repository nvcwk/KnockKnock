//
//  DetailedMarketplaceViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 16/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts
import Foundation
import CoreData

class DetailedMarketplaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var summaryField: UITextField!
    @IBOutlet weak var tourPic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentObject : PFObject!
    var activityArray : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image : PFFile
        let currentObjIti = currentObject["itinerary"]
        
        self.headerLabel.text = currentObjIti.objectForKey("title") as? String
        self.priceLabel.text = String(currentObject.objectForKey("price")!)
        
        // to include below two label once itenerary builder is up, currently no userid associated, will cause to crash
        self.hostLabel.text = currentObject!["host"].objectForKey("fName")! as? String
        self.contactLabel.text = String(currentObject!["host"].objectForKey("contact")!)
        self.summaryField.text = currentObjIti.objectForKey("summary") as? String
        image = currentObjIti.objectForKey("image")! as! PFFile
        
        image.getDataInBackgroundWithBlock({
            (result, error) in
            self.tourPic.image = UIImage(data: result!)
        })
        
        activityArray = currentObjIti["activities"] as! NSArray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    @IBAction func bookButtonTapped(sender: AnyObject) {
        
        
        let bookAlert = UIAlertController(title: "Book?", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.currentObject!["participant"] = PFUser.currentUser()
            
            let myAlert =
            UIAlertController(title:"Booking!!", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            self.currentObject!.saveInBackgroundWithBlock {
                (success : Bool?, error: NSError?) -> Void in
                if (success != nil) {
                    let myAlert =
                    UIAlertController(title:"Done!!", message: "", preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    self.presentViewController(myAlert, animated:true, completion:nil);
                } else {
                    NSLog("%@", error!)
                }
            }
        }))
        
        bookAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(bookAlert, animated: true, completion: nil)
    }
    
    
    // Tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return activityArray.count;
        
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        
        let activity = activityArray[indexPath.row]
        
        cell.header.text = activity.objectForKey("title") as? String
        cell.activityDesc.text = activity.objectForKey("description") as? String
        cell.dayLabel.text = String(activity.objectForKey("day")!)
        
        return cell
    }

}
