//
//  ProfileViewController.swift
//  KnockKnock
//
//  Created by Koh Siu Wei Brenda on 21/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import TextFieldEffects
import SwiftSpinner
import SwiftValidator
import autoAutoLayout
import RSKImageCropper

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var img_profile : PFImageView!
    
    @IBOutlet weak var btn_editSave: UIButton!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_contactNo: UITextField!
    
    @IBOutlet weak var lbl_country: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_licenseStatus: UILabel!
    
    //let imagePicker = UIImagePickerController()
    
    var imgMgmt = ImageProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        
        self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width/2
        self.img_profile.clipsToBounds = true
        
        // Get Current User
        let currentUser = PFUser.currentUser()!;
        
        let fName = currentUser["fName"] as! String
        let lName = currentUser["lName"] as! String
        
        if let country = currentUser["country"] as? String {
            lbl_country.text = country
        }
        
        //navigationItem.title = fName + " " + lName
        
        lbl_name.text = fName + " " + lName
        
        //imagePicker.delegate = self
        
        loadProfilePic()
        setupTxtFields()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFields:",name:"setupProfileTxtFields", object: nil)
        
        imgMgmt = ImageProcessor(controller: self, mode: ImageProcessorCropMode.Circle)
        imgMgmt.delegate = self
    }
    
    @IBAction func actionSelectPic(sender: UITapGestureRecognizer) {
        // KnockKnockImageUtils.imagePicker(self, picker: self.imagePicker)
        imgMgmt.displayPickerOptions()
    }
    
    @IBAction func cancelProfile(segue : UIStoryboardSegue) { }
    
    func reloadFields(notification: NSNotification) {
        setupTxtFields()
    }
    
    func loadProfilePic() {
        let currentUser = PFUser.currentUser()!;
        
        if (currentUser["profilePic"] != nil) {
            img_profile.file = currentUser["profilePic"] as! PFFile
            img_profile.loadInBackground()
        }
    }
    
    func setupTxtFields() {
        let currentUser = PFUser.currentUser()!;
        
        // Setting default values
        tf_email.text = currentUser.email
        
        if let birthDate = currentUser["dob"] as? NSDate {
            tf_birthday.text = KnockKnockUtils.dateToStringDisplay(birthDate)
        }
        
        if let contactNumber = currentUser["contact"] as? Int {
            tf_contactNo.text = String(contactNumber)
        }
        
        if (currentUser["licenseVerified"] != nil) {
            let status = currentUser["licenseVerified"] as! Bool
            if (status) {
                lbl_licenseStatus.text = "License Status: Verified"
            }
        }
    }
    
    @IBAction func actionLogout(sender: UIButton) {
        ParseUtils.logout(self)
    }
}


extension ProfileViewController: ImageProcessorDelegate {
    func getFinalImage(image: UIImage) {
        SwiftSpinner.show("Updating...")
        
        img_profile.image = image
        
        let currentUser = PFUser.currentUser()!
        
        currentUser["profilePic"] = PFFile(data: image.uncompressedPNGData)
        
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                SwiftSpinner.hide()
                
                self.loadProfilePic()
                
                KnockKnockUtils.okAlert(self, title: "Message!", message: "Updated New Pic!", handle: nil)
                
            } else {
                KnockKnockUtils.okAlert(self, title: "Error!", message: "Try Again!", handle: nil)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
}