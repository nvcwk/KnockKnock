//
//  ProfileChangePassViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import SwiftValidator
import SwiftSpinner
import Parse
import ParseUI
import autoAutoLayout

class ProfileChangePassViewController: UIViewController {
    
    @IBOutlet weak var tf_newPass: UITextField!
    
    @IBOutlet weak var tf_cfmPass: UITextField!
    
    @IBOutlet weak var tf_fName: UITextField!
    
    @IBOutlet weak var tf_lName: UITextField!
    
    @IBOutlet weak var image_profile: PFImageView!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        self.image_profile.layer.cornerRadius = self.image_profile.frame.size.width/2
        self.image_profile.clipsToBounds = true
        
        let missTxt = String("Please fill in all inputs")
        
        var user = PFUser.currentUser()
        
        tf_fName.text = user!["fName"] as! String
        tf_lName.text = user!["lName"] as! String
        
        if (user!["profilePic"] != nil) {
            
            var image = user!["profilePic"] as! PFFile
            
            image_profile.file = image
            image_profile.loadInBackground()
        }
        
        validator.registerField(tf_newPass, rules: [RequiredRule(message: missTxt), ConfirmationRule(confirmField: tf_cfmPass, message: "Password do not match!"), KnockKnockRule(regex: "^(?=.*\\d)(?=.*[a-zA-Z])(?!.*[\\W_\\x7B-\\xFF]).{7,20}$", message: "Password does not fit requirements")])
        
    }
    
    @IBAction func actionSave(sender: AnyObject) {
        validator.validate(self)
    }
    
    @IBAction func viewRequirements(sender: UIButton) {
        KnockKnockUtils.okAlert(self, title: "Password Requirements", message: "Should contain 7-20 characters with at least 1 Upper or Lower Alphabet and 1 numerical digit. Special characters are not allowed.", handle: nil)
    }
}

extension ProfileChangePassViewController: ValidationDelegate {
    func validationSuccessful() {
        SwiftSpinner.show("Updating...")
        
        let currentUser = PFUser.currentUser()!
        
        currentUser.password = tf_newPass.text
        
        currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                PFUser.logInWithUsernameInBackground(currentUser.username!, password: currentUser.password!)
                
                SwiftSpinner.hide()
                
                KnockKnockUtils.okAlert(self, title: "Updated!", message: "", handle: { UIAlertAction in
                    self.navigationController?.popToRootViewControllerAnimated(true)}
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

