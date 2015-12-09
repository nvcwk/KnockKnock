//
//  ParseUtils.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class ParseUtils {
    static func loadParse() {
        // Enable Parse Database
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("vYNUU2duZ55QlQNA7XKfjGfOvYmakcAZ0sJOYRHO",
            clientKey: "vBrciAAvdgFipUxAAf12luP8JzaQhHbPs9ELbvs9")
    }
    
    static func checkLogin(controller: UIViewController) {
        if PFUser.currentUser() == nil {
            KnockKnockUtils.storyBoardCall(controller, story: "Credential", animated: true)
        }
    }
    
    static func logout(controller: UIViewController) {
        SwiftSpinner.show("Logging out...")
        
        PFUser.logOutInBackgroundWithBlock( { (error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if( error == nil) {
                KnockKnockUtils.storyBoardCall(controller, story: "Credential", animated: true)
            }
        })
    }
    
    static func signUp(controller: UIViewController, email: String, username: String, password: String, country: String, contact: Int, birthday: NSDate) {
        print("HELLO")
//        let user = PFUser()
//        SwiftSpinner.show("Signing up...")
//        
//        user.email = email
//        user.username = username
//        user.password = password
//
//        user["country"] = country
//        user["contact"] = contact
//        user["birthday"] = birthday
//        
//        
//        
//        user.signUpInBackgroundWithBlock {
//            (succeeded: Bool, error: NSError?) -> Void in
//            SwiftSpinner.hide()
//            
//            if succeeded {
//                KnockKnockUtils.okAlert(controller, title: "Sign up success!", message: "Welcome " + username, handle: { (action:UIAlertAction!) in
//                    KnockKnockUtils.storyBoardCall(controller, story: "Main", animated: true)})
//            } else {
//                KnockKnockUtils.okAlert(controller, title: "Sign up success!", message: "Welcome " + username, handle: nil)
//            }
//        }
    }

}

