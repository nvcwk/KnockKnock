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
import autoAutoLayout

class ProfileEditViewController: UIViewController {
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contactNo: UITextField!
    @IBOutlet weak var profile_img: PFImageView!
    @IBOutlet weak var tf_firstname: UITextField!
    @IBOutlet weak var tf_lastname: UITextField!
    
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_newPassword: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func actionSelectPic(sender: UITapGestureRecognizer) {
        KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
    }
    
    var selectedDate = NSDate()
    let datePicker = UIDatePicker()
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)

        
        let currentUser = PFUser.currentUser()!;
        
        let fName = currentUser["fName"] as! String
        let lName = currentUser["lName"] as! String
        
        navigationItem.title = fName + " " + lName
        
        setupTxtFields()
        loadProfilePic()
        
        self.profile_img.layer.cornerRadius = self.profile_img.frame.size.width/2
        self.profile_img.clipsToBounds = true

        
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
        
        if let firstname = currentUser["fName"] as? String{
            tf_firstname.text = firstname
        }
        
        if let lasttname = currentUser["lName"] as? String{
            tf_lastname.text = lasttname
        }
        
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
        
        print(currentUser.email)
        
        let tempFname = currentUser["fName"]
        let tempLname = currentUser["lName"]
        
        let tempEmail = currentUser.email!
        let tempContact = currentUser["contact"] as! Int
        let tempDob = currentUser["dob"] as! NSDate
        
        currentUser.email = tf_email.text
        currentUser.username = tf_email.text
        currentUser["contact"] = Int(tf_contactNo.text!)
        currentUser["dob"] = selectedDate
        currentUser["fName"] = tf_firstname.text
        currentUser["lName"] = tf_lastname.text
        
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if (success) {
                KnockKnockUtils.okAlert(self, title: "Updated!", message: "", handle: { UIAlertAction in
                        NSNotificationCenter.defaultCenter().postNotificationName("setupProfileTxtFields", object: nil)
                    

                        self.navigationController?.popToRootViewControllerAnimated(false)
                    

                    }
                )
            } else {
                currentUser.email = tempEmail
                currentUser.username = tempEmail
                currentUser["contact"] = tempContact
                currentUser["dob"] = tempDob
                currentUser["fName"] = tempFname
                currentUser["lName"] = tempLname
                
                KnockKnockUtils.okAlert(self, title: "Error!", message: (error?.userInfo["error"])! as! String, handle: nil)
            }
        }
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        KnockKnockUtils.okAlert(self, title: "Error!", message: (errors.values.first?.errorMessage)!, handle: nil)
    }
    
    func loadProfilePic() {
        let currentUser = PFUser.currentUser()!;
        
        profile_img.file = currentUser["profilePic"] as! PFFile
        profile_img.loadInBackground()
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        SwiftSpinner.show("Updating...")
        
        profile_img.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        let currentUser = PFUser.currentUser()!
        
        currentUser["profilePic"] = PFFile(data: UIImagePNGRepresentation(profile_img.image!)!)!
        
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                SwiftSpinner.hide()
                
                self.loadProfilePic()
                
                KnockKnockUtils.okAlert(self, title: "Message!", message: "Updated New Pic!", handle: nil)
                
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

