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
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    var currentObject : PFObject!
    var activityArray = [PFObject]()
    var activities = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image : PFFile
        let currentObjIti = currentObject["itinerary"]
        self.headerLabel.text = currentObjIti.objectForKey("title") as? String
        self.priceLabel.text = String(currentObject.objectForKey("price")!) + " SGD/PAX"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var endDate = currentObject.objectForKey("lastAvailability") as! NSDate
        var startDate = currentObject.objectForKey("startAvailability") as! NSDate
        
        //startDate = startDate.add(days: -1)
        //endDate = endDate.add(days: -1)
        
        self.startDateLabel.text = dateFormatter.stringFromDate(startDate)
        self.endDateLabel.text = dateFormatter.stringFromDate(endDate)
        
        self.hostLabel.text = String(currentObject!["host"].objectForKey("fName")!)
        self.contactLabel.text = String(currentObject["host"].objectForKey("contact")!)
        self.summaryField.text = currentObjIti.objectForKey("summary") as? String
        image = currentObjIti.objectForKey("image")! as! PFFile
        
        image.getDataInBackgroundWithBlock({
            (result, error) in
            self.tourPic.image = UIImage(data: result!)
        })
        
        activityArray = currentObjIti["activities"] as! [PFObject]
        
        let query = PFQuery(className: "Activity")
        for a1 in activityArray{
        query.whereKey("objectId", matchesRegex: a1.objectId! )
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
        
            if error == nil{
                if let objects = objects as [PFObject]!{

                    for object in objects {
                        self.activities.append(object)
                    }
                }
                
            }else{
                //log details of the failure
                print("error: \(error!)  \(error!.userInfo)")
            }
        }
        
        }
        sleep(3)
        do_table_refresh()
    }

    func do_table_refresh(){
        dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
        return
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.header.text = activity["title"] as? String
        cell.activityDesc.text = activity.objectForKey("description") as? String
        cell.dayLabel.text = String(activity.objectForKey("day")!)
        
        return cell
    }

}
