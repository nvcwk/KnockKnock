//
//  ItiActivityViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 19/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import GoogleMaps

class ItiActivityViewController: UIViewController {

    @IBOutlet weak var lb_day: UILabel!
    @IBOutlet weak var tf_location: UITextField!
    
    @IBOutlet weak var tf_meetingTime: UITextField!
    
    var day = 0
    var placePicker: GMSPlacePicker?
    
    let timePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.datePickerMode = UIDatePickerMode.Time
        timePicker.maximumDate = NSDate()
        timePicker.addTarget(self, action: Selector("updateMeeting:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_meetingTime.inputView = timePicker
        
        lb_day.text = "Day " + String(day)
    }
    
    func updateMeeting(sender: UIDatePicker) {
        tf_meetingTime.text = KnockKnockUtils.timeToString(sender.date)
        //selectedDate = sender.date
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
                self.tf_location.text = place.formattedAddress
            } else {
                print("No place selected")
            }
        })
    }
   
}
