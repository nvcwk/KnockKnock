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
        
        let user = PFUser()
        SwiftSpinner.show("Signing up...")
        
        user.email = email
        user.username = username
        user.password = password
        
        user["country"] = country
        user["contact"] = contact
        user["dob"] = birthday
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                
                KnockKnockUtils.okAlert(controller, title: "Error!", message: String(errorString!), handle: nil)
                // Show the errorString somewhere and let the user try again.
            } else {
                KnockKnockUtils.okAlert(controller, title: "Sign up success!", message: "Welcome " + username, handle: { (action:UIAlertAction!) in
                    KnockKnockUtils.storyBoardCall(controller, story: "Profile", animated: true, view:"profilePic")})
            }
        }
    }
    
    static func updateProfileImage(image: UIImage, controller: UIViewController) {
        SwiftSpinner.show("Loading...")
        
        let user = currentUser()
        
        let imageFile:PFFile = PFFile(data: UIImagePNGRepresentation(image)!)!
        
        user["profilePic"] = imageFile
        
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                
                KnockKnockUtils.okAlert(controller, title: "Error!", message: String(errorString!), handle: nil)
            } else {
                KnockKnockUtils.storyBoardCall(controller, story: "Main", animated: true)
            }
        }
    }
    
    static func currentUser() -> PFUser {
        return PFUser.currentUser()!
    }
}

