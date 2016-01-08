//
//  ProfileViewController.swift
//  KnockKnock
//
//  Created by Koh Siu Wei Brenda on 21/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var changePhoto : UIButton!

    @IBOutlet weak var hostTours: UIButton!
    @IBOutlet weak var joinedTours: UIButton!
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contactNo: UITextField!
    
    
    var selectedDate = NSDate()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Current User
        var current_User = PFUser.currentUser();
        
        // Setting default values
        tf_email.text = current_User?.email
        
        if let birthDate = PFUser.currentUser()!["dob"] as? NSDate {
            
            tf_birthday.text = KnockKnockUtils.dateToString(birthDate)
            //            var dateFormatter = NSDateFormatter()
            //            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            //            tf_birthday.text = dateFormatter.stringFromDate(birthDate)
        }
        
        if let contactNumber = PFUser.currentUser()!["contact"] as? Int {
            tf_birthday.text = String(contactNumber)
        }
        
    }
    
    
    @IBAction func onClick_editprofile(sender: AnyObject) {
        
        if(editProfile.titleLabel?.text != "Save"){
            enableEditing()
            editProfile.titleLabel?.text = "Save"
            changePhoto.titleLabel?.text = "Cancel"
            
        } else {
            
            ParseUtils.updateUser(self, email: tf_email.text!, dob: selectedDate, contact: Int(tf_contactNo.text!)!)
            disableEditing()
            editProfile.titleLabel?.text = "Edit Profile"
        }

    }
    
    @IBAction func onClick_save(sender: AnyObject){
        
    }

    
    
    func enableEditing(){
        tf_email.enabled == true
        
        tf_birthday.enabled == true
        
        // Date Picker
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: Selector("updateBirthday:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_birthday.inputView = datePicker
        
        tf_contactNo.enabled == true
    }
    
    
    func updateBirthday(sender: UIDatePicker) {
        tf_birthday.text = KnockKnockUtils.dateToString(sender.date)
        selectedDate = sender.date
    }
    
    
    func disableEditing(){
        tf_email.enabled == false
        tf_birthday.enabled == false
        tf_contactNo.enabled == false
    }
}