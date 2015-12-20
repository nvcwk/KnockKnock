//
//  ItiActivityViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 19/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import SwiftValidator

class ItiActivityViewController: UIViewController {
    @IBOutlet weak var tf_address: UITextField!
    @IBOutlet weak var tf_title: UITextField!
    @IBOutlet weak var tv_desc: UITextView!
    @IBOutlet weak var tf_cordinate: UITextField!
    @IBOutlet weak var tf_meetingTime: UITextField!
    
    var day = 0
    var selectedCor: CLLocationCoordinate2D?
    var selectedTime: NSDate?
    
    var activity = Activity()
    
    var placePicker: GMSPlacePicker?
    
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.datePickerMode = UIDatePickerMode.Time
        timePicker.addTarget(self, action: Selector("updateMeeting:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_meetingTime.inputView = timePicker
        
        tv_desc.delegate = self
        
        self.navigationItem.title = "Day " + String(day)
        
        tf_title.text = activity.title
        tf_meetingTime.text = KnockKnockUtils.timeToString(activity.meetingTime)
        tv_desc.text = activity.description
        tf_cordinate.text = activity.cordinatesText
        tf_address.text = activity.address
        selectedCor = activity.cor
        selectedTime = activity.meetingTime
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "saveToActivitiesView") {
            if(tf_title.text!.isEmpty || tv_desc.text!.isEmpty || tf_cordinate.text!.isEmpty || tf_meetingTime.text!.isEmpty) {                KnockKnockUtils.okAlert(self, title: "Error!", message: "Please fill in all fields!", handle: nil)
                return false
            }
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue .identifier == "saveToActivitiesView") {
            let activity = Activity()
            
            activity.title = tf_title.text!
            activity.day = day
            activity.description = tv_desc.text
            activity.cor = selectedCor
            activity.address = tf_address.text!
            activity.meetingTime = selectedTime!
            activity.cordinatesText = tf_cordinate.text!
            activity.isCompleted = true
            
            let controller = segue.destinationViewController as! ItiActivitiesViewController
            controller.activities[day - 1] = activity
        }
    }
    
    func updateMeeting(sender: UIDatePicker) {
        tf_meetingTime.text = KnockKnockUtils.timeToString(sender.date)
        selectedTime = sender.date
    }
    
    @IBAction func actionSetLocation(sender: UIButton) {
        
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.tf_address.text = place.formattedAddress
                self.tf_cordinate.text = "Lat: " + place.coordinate.latitude.description + " " + "Long: " + place.coordinate.longitude.description
                self.selectedCor = place.coordinate
            } else {
                print("No place selected")
            }
        })
    }
    
}


extension ItiActivityViewController : UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let checkString = "\n"
        let crCount = countOccurrences(textView.text, forSubstring: checkString) + countOccurrences(text, forSubstring: checkString)
        
        if(crCount > 4) {
            return false
        }
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        
        return newLength <= 200
    }
    
    private func countOccurrences(toCheck: String, forSubstring: String) -> Int
    {
        var tokenArray = toCheck.componentsSeparatedByString(forSubstring)
        return tokenArray.count-1
    }
}
