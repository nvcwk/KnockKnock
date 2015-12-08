//
//  LoginViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var btn_forget: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailIcon = UIImageView(image: UIImage(named: "username"))
        emailIcon.frame = CGRect(x: 60, y: 15, width: 25, height: 25)
        
        tf_username.leftView = emailIcon
        tf_username.leftViewMode = UITextFieldViewMode.Always
        
        let passwordIcon = UIImageView(image: UIImage(named: "password"))
        passwordIcon.frame = CGRect(x: 60, y: 15, width: 25, height: 25)
        
        tf_password.leftView = passwordIcon
        tf_password.leftViewMode = UITextFieldViewMode.Always
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionLogin(sender: UIButton) {
        let user = tf_username.text!
        let pass = tf_password.text!

        if (user.isEmpty || pass.isEmpty) {
            UIAlertView(title: "Missing Input", message: "Key in all fields!", delegate: self, cancelButtonTitle: "OK").show()
        } else {
            SwiftSpinner.show("Logging in....") // Run a spinner to show a task in progress

            PFUser.logInWithUsernameInBackground(tf_username.text!, password: tf_password.text!, block: {
                (user: PFUser?, error: NSError?) -> Void in
                SwiftSpinner.hide()
                
                if ((user) != nil) {
                    StoryBoardCalls.call(self, story: "Main")
                } else {
                    UIAlertView(title: "Error Logging In!", message: "", delegate: self, cancelButtonTitle: "OK").show()
                }
            })
        }
    }
    
    @IBAction func backLogin(segue:UIStoryboardSegue) {
    }
}
