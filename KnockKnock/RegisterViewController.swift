//
//  RegisterViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 9/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tf_country: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_pass: UITextField!
    @IBOutlet weak var tf_cfmPass: UITextField!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contact: UITextField!
    
    var selectedDate = NSDate()
    
    //let countryPickerView = CountryPicker()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: Selector("updateBirthday:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_birthday.inputView = datePicker
    }
    
        func updateBirthday(sender: UIDatePicker) {
            tf_birthday.text = KnockKnockUtils.dateToString(sender.date)
            selectedDate = sender.date
        }
    
    @IBAction func actionSignUser(sender: UIButton) {
        print("heello")
    }
}
