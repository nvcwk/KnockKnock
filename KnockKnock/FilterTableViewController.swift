//
//  FilterTableViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 21/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    @IBOutlet weak var tf_startDate: UITextField!
    @IBOutlet weak var tf_endDate: UITextField!
    @IBOutlet weak var tf_minPrice: UITextField!
    @IBOutlet weak var tf_maxPrice: UITextField!
    @IBOutlet weak var ctrl_days: UISegmentedControl!
    
    var startDate = 1.years.ago()
    var endDate = 5.years.fromNow()
    var minPrice = 0
    var maxPrice = 999
    var days = 5
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ctrl_days.selectedSegmentIndex = days - 1
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(startDate)
        tf_endDate.text = KnockKnockUtils.dateToStringDisplay(endDate)
        tf_minPrice.text = String(minPrice)
        tf_maxPrice.text = String(maxPrice)
        
        tf_minPrice.delegate = self
        tf_maxPrice.delegate = self
        
        tf_minPrice.addTarget(self, action: "minDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        tf_maxPrice.addTarget(self, action: "maxDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = NSDate()
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_startDate.inputView = startDatePicker
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = NSDate()
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_endDate.inputView = endDatePicker
    }
    
    func minDidChange(textField: UITextField) {
        if(textField.text!.isEmpty) {
            minPrice = 0
        } else {
            minPrice = Int(textField.text!)!
        }
        
    }
    
    func maxDidChange(textField: UITextField) {
        if(textField.text!.isEmpty) {
            maxPrice = 999
        } else {
            maxPrice = Int(textField.text!)!
        }
    }
    
    func updateStartDate(sender: UIDatePicker) {
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
        startDate = sender.date
        
        if(sender.date >= startDate) {
            tf_endDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
            endDate = sender.date
        } else {
            tf_endDate.text = KnockKnockUtils.dateToStringDisplay(startDate)
            endDate = startDate
            
        }
    }
    
    func updateEndDate(sender: UIDatePicker) {
        if(sender.date >= startDate) {
            tf_endDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
            endDate = sender.date
        } else {
            tf_endDate.text = KnockKnockUtils.dateToStringDisplay(startDate)
            endDate = startDate
            
        }
    }
    
    @IBAction func actionSelectDays(sender: UISegmentedControl) {
        days = ctrl_days.selectedSegmentIndex + 1
    }
}

extension FilterTableViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 3 // Bool
    }

}
