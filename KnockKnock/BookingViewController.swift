//
//  BookingViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 12/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import FSCalendar
import Parse
import ParseUI
import GMStepper

class BookingViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var cal: FSCalendar!
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paxLabel: UILabel!
    
    var EndDate = NSDate()
    var EndDate2 = NSDate()
    var StartDate = NSDate()
    var StartDate2 = NSDate()
    var UserselectedDate = NSDate()
    var bookedDatesArray = [String]()
    var bookedDatesArray2 = [NSDate]()
    var pax : Int = 1
    var price = Int()
    var selectedDate = NSDate()
    var finalPrice : Int = 0
    var host = PFUser()
    var marketplace : PFObject!
    var itinerary : PFObject!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        StartDate2 = StartDate.add(days: 1)
        EndDate2 = EndDate.add(days: -1)
        bookedDatesArray2.append(StartDate2)
        bookedDatesArray2.append(EndDate2)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        for stringDates in bookedDatesArray{
            if let date = dateFormatter.dateFromString(stringDates){
                var date = dateFormatter.dateFromString(stringDates)!
                bookedDatesArray2.append(date)
            }
            
        }
       self.paxLabel.text = String(pax)
        self.priceLabel.text = String(price)
       
    }
    @IBAction func stepperTapped(sender: AnyObject) {
        var currentValue = Int(stepper.value)
        self.paxLabel.text = "\(currentValue)"
        var newPrice  = price * currentValue
        self.priceLabel.text = String(newPrice)
        pax = Int(currentValue)
        finalPrice = newPrice

    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set date range
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return StartDate
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return EndDate
    }
    
    
    //show marking that some dates not available
    func calendar(calendar: FSCalendar!, imageForDate date: NSDate!) -> UIImage! {
       // return bookedDatesArray2.contains(date) ? UIImage(named: "cross") : nil
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        for dates in bookedDatesArray2{
            if (dateFormatter.stringFromDate(dates) == dateFormatter.stringFromDate(date)){
                return UIImage(named: "cross")
            }
        }
        return nil
    }


    //prevent dates from being selected
    func calendar(calendar: FSCalendar!, shouldSelectDate date: NSDate!) -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        for dates in bookedDatesArray2{
        if (dateFormatter.stringFromDate(dates) == dateFormatter.stringFromDate(date)){
                return false
        }
        }
        // if (bookedDatesArray2.contains(dateFormatter.stringFromDate(date))) {
         //   return false
        //}
        return true
    }
    
    
    //when date is selected
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        selectedDate = date

    }
    
    @IBAction func confirmBtnTapped(sender: AnyObject) {
        let bookAlert = UIAlertController(title: "Book?", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            var booking = PFObject(className: "Pending")
            booking["Requester"] = PFUser.currentUser()
            booking["Date"] = self.selectedDate
            booking["Host"] = self.host
            booking["Pax"] = Int(self.pax)
            booking["Total"] = Int(self.finalPrice)
            booking["Marketplace"] = self.marketplace
            booking["Itinerary"] = self.itinerary
            let myAlert =
            UIAlertController(title:"Sending to host!!", message: "Please Wait...", preferredStyle: UIAlertControllerStyle.Alert);
            
            booking.saveInBackgroundWithBlock {
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
    
    
    }
