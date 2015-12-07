//
//  LoginViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameIcon = UIImageView(image: UIImage(named: "username"))
        usernameIcon.frame = CGRect(x: 30, y: 15, width: 30, height: 30)
    
        tf_username.leftView = usernameIcon
        tf_username.leftViewMode = UITextFieldViewMode.Always
        
        let passwordIcon = UIImageView(image: UIImage(named: "password"))
        passwordIcon.frame = CGRect(x: 30, y: 15, width: 30, height: 30)
        
        tf_password.leftView = passwordIcon
        tf_password.leftViewMode = UITextFieldViewMode.Always
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
