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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameIcon = UIImageView(image: UIImage(named: "username"))
        usernameIcon.frame = CGRect(x: 30, y: 15, width: 25, height: 25)
        
        tf_username.leftView = usernameIcon
        tf_username.leftViewMode = UITextFieldViewMode.Always
        
        let passwordIcon = UIImageView(image: UIImage(named: "password"))
        passwordIcon.frame = CGRect(x: 30, y: 15, width: 25, height: 25)
        
        tf_password.leftView = passwordIcon
        tf_password.leftViewMode = UITextFieldViewMode.Always
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionLogin(sender: UIButton) {
        // Run a spinner to show a task in progress
        SwiftSpinner.show("Logging in....")
        
        // Send a request to login
        PFUser.logInWithUsernameInBackground(tf_username.text!, password: tf_password.text!, block: {
            (user: PFUser?, error: NSError?) -> Void in
                    
            if ((user) != nil) {
                SwiftSpinner.hide()
                
                StoryBoardCalls.call(self, story: "Main")
            } else {
                //let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                //alert.show()
            }
        })
        
    }
}
