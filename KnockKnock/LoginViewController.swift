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
import ParseFacebookUtilsV4

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
            KnockKnockUtils.okAlert(self, title: "Missing Input", message: "Key in all inputs!", handle: nil)
        } else {
            SwiftSpinner.show("Logging in....") // Run a spinner to show a task in progress

            PFUser.logInWithUsernameInBackground(tf_username.text!, password: tf_password.text!, block: {
                (user: PFUser?, error: NSError?) -> Void in
                SwiftSpinner.hide()
                
                if ((user) != nil) {
                    KnockKnockUtils.storyBoardCall(self, story: "Main", animated: true)
                } else {
                    KnockKnockUtils.okAlert(self, title: "Error", message: "Incorrect Username or Password", handle: nil)
                }
            })
        }
    }
    
    @IBAction func actionFBLogin(sender: UIButton) {
        SwiftSpinner.show("Logging in....")
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"]) {
            (user: PFUser?, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if let user = user {
                KnockKnockUtils.storyBoardCall(self, story: "Main", animated: false)
            } else {
                KnockKnockUtils.okAlert(self, title: "Error Logging In!", message: "Try Again!", handle: nil)
            }
        }
    }
    
    @IBAction func backLogin(segue:UIStoryboardSegue) {
    }
}
