//
//  BookingViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 12/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import FSCalendar

class BookingViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var cal: FSCalendar!
    
    
    var EndDate = NSDate()
    var EndDate2 = NSDate()
    var StartDate = NSDate()
    var StartDate2 = NSDate()
    var UserselectedDate = NSDate()
    var bookedDatesArray = [String]()
    var bookedDatesArray2 = [NSDate]()


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
        print(bookedDatesArray2)
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
        // if (bookedDatesArray2.contains(dateFormatter.stringFromDate(date))) {
        //   return false
        //}
        return nil
    }


    //show dots
    /*func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        return true
    }
    */
    
    //prevent dates from being selected
    func calendar(calendar: FSCalendar!, shouldSelectDate date: NSDate!) -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
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
        print(date)

    }
    
    
    
    }
