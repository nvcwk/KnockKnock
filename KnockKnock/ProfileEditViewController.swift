//
//  ProfileEditViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ZFRippleButton
import TextFieldEffects
import SwiftSpinner
import SwiftValidator

class ProfileEditViewController: UIViewController {
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contactNo: UITextField!
    
    var selectedDate = NSDate()
    let datePicker = UIDatePicker()
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()!;
        
        let fName = currentUser["fName"] as! String
        let lName = currentUser["lName"] as! String
        
        navigationItem.title = fName + " " + lName
        
        setupTxtFields()
        
        let missTxt = String("Please fill in all inputs")
        
        validator.registerField(tf_email, rules: [RequiredRule(message: missTxt), EmailRule(message: "Invalid E-Mail Adress")])
        validator.registerField(tf_contactNo, rules: [RequiredRule(message: missTxt)])
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: Selector("updateDob:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_birthday.inputView = datePicker
        
    }
    
    
    func updateDob(sender: UIDatePicker) {
        tf_birthday.text = KnockKnockUtils.dateToString(sender.date)
        selectedDate = sender.date
    }
    
    @IBAction func actionSave(sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    func setupTxtFields() {
        let currentUser = PFUser.currentUser()!;
        
        // Setting default values
        tf_email.text = currentUser.email
        
        if let birthDate = currentUser["dob"] as? NSDate {
            tf_birthday.text = KnockKnockUtils.dateToString(birthDate)
        }
        
        if let contactNumber = currentUser["contact"] as? Int {
            tf_contactNo.text = String(contactNumber)
        }
    }
    
}

extension ProfileEditViewController: ValidationDelegate {
    func validationSuccessful() {
        SwiftSpinner.show("Updating...")
        
        let currentUser = PFUser.currentUser()!
        
        currentUser.email = tf_email.text
        currentUser["contact"] = Int(tf_contactNo.text!)
        currentUser["dob"] = selectedDate
        
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                SwiftSpinner.hide()
                
                KnockKnockUtils.okAlert(self, title: "Updated!", message: "", handle: { UIAlertAction in
                        NSNotificationCenter.defaultCenter().postNotificationName("setupProfileTxtFields", object: nil)
                    
                        self.navigationController?.popToRootViewControllerAnimated(false)
                    }
                )
                
                
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
        }
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        KnockKnockUtils.okAlert(self, title: "Error!", message: (errors.values.first?.errorMessage)!, handle: nil)
    }
}

