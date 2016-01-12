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
    var bookedDatesArray = [NSDate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        StartDate2 = StartDate.add(days: 1)
        EndDate2 = EndDate.add(days: -1)
        bookedDatesArray.append(StartDate2)
        bookedDatesArray.append(EndDate2)
        
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
        return bookedDatesArray.contains(date) ? UIImage(named: "cross") : nil
    }


    //show dots
    /*func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        return true
    }
    */
    
    
    
    //prevent dates from being selected
    func calendar(calendar: FSCalendar!, shouldSelectDate date: NSDate!) -> Bool {
        if (bookedDatesArray.contains(date)) {
            return false
        }
        return true
    }
    
    
    //when date is selected
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        print(date)
    }
    
    
    
    }
