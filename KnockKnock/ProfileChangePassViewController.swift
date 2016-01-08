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

class ProfileChangePassViewController: UIViewController {
    
    @IBOutlet weak var tf_newPass: UITextField!
    
    @IBOutlet weak var tf_cfmPass: UITextField!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let missTxt = String("Please fill in all inputs")
        
        validator.registerField(tf_newPass, rules: [RequiredRule(message: missTxt), ConfirmationRule(confirmField: tf_cfmPass, message: "Password do not match!"), KnockKnockRule(regex: "^(?=.*\\d)(?=.*[a-zA-Z])(?!.*[\\W_\\x7B-\\xFF]).{7,20}$", message: "Password does not fit requirements")])
        
    }
    
    @IBAction func actionSave(sender: AnyObject) {
        validator.validate(self)
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

