//
//  PubEditViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftSpinner
import autoAutoLayout

class PubDetailsEditViewController: UIViewController {
    
    var publishObj = PFObject(className: "MarketPlace")

    @IBOutlet weak var lb_title: UILabel!
    
    @IBOutlet weak var tf_price: UITextField!

    @IBOutlet weak var tf_startDate: UITextField!
    
    @IBOutlet weak var tf_endDate: UITextField!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    var selectedStartDate = NSDate()
    var selectedEndDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        tf_price.delegate = self
        
        var itinerary = publishObj["itinerary"] as! PFObject
        lb_title.text = itinerary["title"] as! String

        tf_price.text = String(publishObj["price"] as! Int)
        
        selectedStartDate = publishObj["startAvailability"] as! NSDate
        
        selectedEndDate = publishObj["lastAvailability"] as! NSDate
        
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(selectedStartDate)
        
        tf_endDate.text = KnockKnockUtils.dateToStringDisplay(selectedEndDate)
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = NSDate()
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_startDate.inputView = startDatePicker
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(5.days.fromDate(NSDate()))
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = NSDate()
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_endDate.inputView = endDatePicker
        tf_endDate.text = KnockKnockUtils.dateToStringDisplay(5.days.fromDate(NSDate()))
    }
    
    func updateStartDate(sender: UIDatePicker) {
        tf_startDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
        publishObj["startAvailability"] = sender.date
        selectedStartDate = sender.date
        endDatePicker.minimumDate = sender.date
        
        if(selectedEndDate < sender.date) {
            tf_endDate.text = ""
        }
    }
    
    func updateEndDate(sender: UIDatePicker) {
        tf_endDate.text = KnockKnockUtils.dateToStringDisplay(sender.date)
        publishObj["lastAvailability"] = sender.date
        selectedEndDate = sender.date
    }
    


    @IBAction func actionUpdate(sender: AnyObject) {
        var price = Int(tf_price.text!)
        
        if (price == nil || price! == 0){
            KnockKnockUtils.okAlert(self, title: "Please Check Price", message: "Please enter valid price!", handle: nil)
        }else{
            
        
        SwiftSpinner.show("Updating...")
        
        publishObj["price"] = Int(tf_price.text!)
        
        self.publishObj.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if(error == nil) {
                
                KnockKnockUtils.okAlert(self, title: "Updated!", message: "", handle: { UIAlertAction in
                    NSNotificationCenter.defaultCenter().postNotificationName("loadPublish", object: nil)
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                })
            }
        })
            
        }
    }

}

extension PubDetailsEditViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 3 // Bool
    }
}
