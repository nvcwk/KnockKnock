//
//  RegisterViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 9/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import CountryPicker
import SwiftValidator

class RegisterViewController: UIViewController, CountryPickerDelegate, ValidationDelegate {
    
    @IBOutlet weak var tf_country: UITextField!
    @IBOutlet weak var tf_fName: UITextField!
    @IBOutlet weak var tf_lName: UITextField!
    @IBOutlet weak var tf_pass: UITextField!
    @IBOutlet weak var tf_cfmPass: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contact: UITextField!
    
    var selectedDate = NSDate()
    
    let countryPickerView = CountryPicker()
    let datePicker = UIDatePicker()
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        countryPickerView.delegate = self
        countryPickerView.selectedLocale = NSLocale.currentLocale()
        tf_country.inputView = countryPickerView
        tf_country.text = countryPickerView.selectedCountryName
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: Selector("updateBirthday:"),
            forControlEvents:UIControlEvents.ValueChanged)
        tf_birthday.inputView = datePicker
        
        let missTxt = String("Please fill in all inputs")
        
        validator.registerField(tf_email, rules: [RequiredRule(message: missTxt), EmailRule(message: "Invalid E-Mail Adress")])
        validator.registerField(tf_pass, rules: [RequiredRule(message: missTxt), ConfirmationRule(confirmField: tf_cfmPass, message: "Password do not match!"), KnockKnockRule(regex: "^(?=.*\\d)(?=.*[a-zA-Z])(?!.*[\\W_\\x7B-\\xFF]).{7,20}$", message: "Password does not fit requirements")])
        validator.registerField(tf_fName, rules: [RequiredRule(message: missTxt), MaxLengthRule(length: 10, message: "First Name should be max 10 characters"), KnockKnockRule(regex: "^[a-z]{1,10}$", message: "First Name must have characters only")])
        validator.registerField(tf_lName, rules: [RequiredRule(message: missTxt), MinLengthRule(length: 2, message: "Last Name should be min 2 characters"), MaxLengthRule(length: 10, message: "Last Name should be max 10 characters"), KnockKnockRule(regex: "^[a-z]{2,10}$", message: "Last Name must have characters only")])
        validator.registerField(tf_country, rules: [RequiredRule(message: missTxt)])
        validator.registerField(tf_birthday, rules: [RequiredRule(message: missTxt)])
        validator.registerField(tf_contact, rules: [RequiredRule(message: missTxt)])
    }
    
    func updateBirthday(sender: UIDatePicker) {
        tf_birthday.text = KnockKnockUtils.dateToString(sender.date)
        selectedDate = sender.date
    }
    
    func countryPicker(picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        tf_country.text = name
    }
    
    @IBAction func actionSignUser(sender: UIButton) {
        validator.validate(self)
    }
    
    func validationSuccessful() {
        ParseUtils.signUp(self, email: tf_email.text!, username: tf_email.text!, fName: tf_fName.text!, lName: tf_lName.text!, password: tf_pass.text!, country: tf_country.text!, contact: Int(tf_contact.text!)!, birthday: selectedDate)
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        KnockKnockUtils.okAlert(self, title: "Error!", message: (errors.values.first?.errorMessage)!, handle: nil)
    }

    @IBAction func viewRequirements(sender: UIButton) {
        KnockKnockUtils.okAlert(self, title: "Password Requirements", message: "Should contain 7-20 characters with at least 1 Upper or Lower Alphabet and 1 numerical digit. Special characters are allowed.", handle: nil)
    }
}
