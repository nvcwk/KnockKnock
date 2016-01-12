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
import CKCalendar


class DetailedMarketplaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CKCalendarDelegate {
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
    
    var bookedDatesArray = [String]()
    var numOfDays: Int!
    var startDate = NSDate()
    var endDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image : PFFile
        let currentObjIti = currentObject["itinerary"]
        self.headerLabel.text = currentObjIti.objectForKey("title") as? String
        self.priceLabel.text = String(currentObject.objectForKey("price")!) + " SGD/PAX"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        endDate = currentObject.objectForKey("lastAvailability") as! NSDate
        startDate = currentObject.objectForKey("startAvailability") as! NSDate
        
       // startDate = startDate.add(days: -1)
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
        
        numOfDays = activityArray.count - 1
        
        bookedDatesArray = currentObject["bookedDate"] as! [String]
        print(bookedDatesArray)
        
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
    
    // Tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return activityArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! MarketActivityTableViewCell
        
        let activity = activityArray[indexPath.row]
        
        cell.header.text = activity["title"] as? String
        cell.activityDesc.text = activity.objectForKey("description") as? String
        cell.dayLabel.text = String(activity.objectForKey("day")!)
        
        return cell
    }
    
    @IBAction func bookButtonTapped(sender: AnyObject) {
      /*
        let calendar = createCalendar()
        self.view!.addSubview(calendar)
        calendar.delegate = self
        */
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestViewController : BookingViewController = segue.destinationViewController as! BookingViewController
        DestViewController.StartDate = startDate
        DestViewController.EndDate = endDate
        DestViewController.bookedDatesArray = bookedDatesArray
    }
    
    
    
    
    
    
    
    
    
    /*func calendar(calendar: CKCalendarView!, willSelectDate date: NSDate!) -> Bool {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringStartDateSelected = dateFormatter.stringFromDate(date)
        let stringEndDateSelected = dateFormatter.stringFromDate(numOfDays.days.fromDate(date))
        
        
        let format = NSDateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        format.timeZone = NSTimeZone(name: "GMT")

        
        
        let startDateSelected = format.dateFromString(stringStartDateSelected)!
        let endDateSelected = format.dateFromString(stringEndDateSelected)!
        
        
        
        //Prevent user from selecting the booked dates
        for object in bookedDatesArray as [NSDate]{
            
            let stringObjectDate = dateFormatter.stringFromDate(object)
            
            if (object > startDateSelected && object < endDateSelected) || (stringObjectDate == stringStartDateSelected && stringObjectDate == stringEndDateSelected){
                return false
            }
        }
        return true
    }*/
    
    func calendar(calendar: CKCalendarView!, didSelectDate date: NSDate!) {
        
        if date != nil{
            print(date)
        }else{
            //Deselect and return nil for date
        }
    }

    
    func createCalendar() -> CKCalendarView {
        let calendar: CKCalendarView = CKCalendarView()
        calendar.center = CGPointMake(self.view.frame.size.width  / 2,
            self.view.frame.size.height / 2)
        
        return calendar
    }
    
    
    
}
