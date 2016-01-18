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

    var StartDate = NSDate()

    var bookedDatesArray = [NSDate]()
    var pax : Int = 1
    var price = Int()
    var selectedDate = [NSDate]()
    var finalPrice : Int = 0
    var host = PFUser()
    var marketplace : PFObject!
    var itinerary : PFObject!
    var numOfDays = Int()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cal.allowsMultipleSelection = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        
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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        for dates in bookedDatesArray{
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
        for dates in bookedDatesArray{
        if (dateFormatter.stringFromDate(dates) == dateFormatter.stringFromDate(date)){
                return false
        }
        }
        return true
    }
    
    
    //when date is selected
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        selectedDate.append(date)

    }
    
    func calendar(calendar: FSCalendar!, didDeselectDate date: NSDate!) {
        var index = 0
        for dateInArray in selectedDate {
            if (dateInArray == date){
            selectedDate.removeAtIndex(index)
        }else{
            index = index + 1
            }
            
        }
    }
    
    @IBAction func confirmBtnTapped(sender: AnyObject) {
        //validation to check if dates are consecutive
        var testerDates = [NSDate]()
        var tester = false
        selectedDate.sort()
        var first = selectedDate.first
        testerDates.append(first!)
        for (var i = 0; i < numOfDays; i++){
            var tempDate = first?.add(days: i)
            testerDates.append(tempDate!)
        }
        
        for date in testerDates {
            if (!selectedDate.contains(date)){
                tester = true
            }
        }
        
        //validation to check if days equal number of days of tour
        if (selectedDate.count != numOfDays){
            
            var alertTitle = "Days Count Mismatch"
            var message = String("Please select \(numOfDays) consecutive days")
            let okText = "OKAY"
            
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButtton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButtton)
            
            presentViewController(alert, animated: true, completion: nil)
            
        }else if(tester){
            var alertTitle = "Please select consecutive days"
            var message = String("There must not be gaps in between dates")
            let okText = "OKAY"
            
            let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButtton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButtton)
            
            presentViewController(alert, animated: true, completion: nil)

        }else{
            
            
            let bookAlert = UIAlertController(title: "Book?", message: "Confirmed?", preferredStyle: UIAlertControllerStyle.Alert)
            
            bookAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                var booking = PFObject(className: "Pending")
                booking["Requester"] = PFUser.currentUser()
                booking["Date"] = self.selectedDate
                booking["Host"] = self.host
                booking["Pax"] = Int(self.pax)
                booking["Total"] = Int(self.finalPrice)
                booking["Marketplace"] = self.marketplace
            booking["Marketplace"] = self.marketplace
                booking["Status"] = "Pending"
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
    
    
    }
