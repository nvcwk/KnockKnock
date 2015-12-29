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
    
    var header: String! = ""
    var price: String! = ""
    var host: PFUser!
    var summary: String! = ""
    var picFile: PFFile!
    var currentObject : PFObject?
    var activities = NSArray()
    var tours = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerLabel.text = header
        self.priceLabel.text = String(price)
        
        // to include below two label once itenerary builder is up, currently no userid associated, will cause to crash
        
        let guide = currentObject!["host"] as! PFUser
        
        let query = PFQuery(className: "User")
        do {
            try guide.fetchIfNeeded();
            self.hostLabel.text = guide["fName"] as! String
            self.contactLabel.text = String(guide["contact"])
        } catch is ErrorType {
            print("Invalid Selection.")
        }

        
        
        
        self.summaryField.text = summary
        picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                self.tourPic.image = UIImage(data:imageData!)
            }
        }
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
      /*
        if(searchActive) {
            return filteredHeaderArray.count
        }*/
        return activities.count;
        
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        
        
       let actvitiy = activities[indexPath.row]
        
        let query2 = PFQuery(className: "Activity")
       
        do {
           let act = try query2.getObjectWithId(actvitiy["objectId"] as! String!)
            cell.header.text = act["title"] as! String
            cell.activityDesc.text = act["description"] as! String
            cell.dayLabel.text = String(act["day"])
        } catch is ErrorType {
            print("Invalid Selection.")
        }
    
        return cell
            }
    
   
    
    
    

}
