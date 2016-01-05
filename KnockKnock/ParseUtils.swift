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
    
    // Check user login
    static func checkLogin(controller: UIViewController) -> Bool {
        if PFUser.currentUser() == nil {
            KnockKnockUtils.storyBoardCall(controller, story: "Credential", animated: true)
            
            return false
        }
        return true
    }
    
    // Logout
    static func logout(controller: UIViewController) {
        SwiftSpinner.show("Logging out...")
        
        PFUser.logOutInBackgroundWithBlock( { (error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if( error == nil) {
                KnockKnockUtils.storyBoardCall(controller, story: "Credential", animated: true)
            }
        })
    }
    
    // Sign User Up
    static func signUp(controller: UIViewController, email: String, username: String, fName: String, lName: String, password: String, country: String, contact: Int, birthday: NSDate) {
        
        let user = PFUser()
        SwiftSpinner.show("Signing up...")
        
        user.email = email
        user.username = username
        user.password = password
        
        user["country"] = country
        user["contact"] = contact
        user["dob"] = birthday
        user["fName"] = fName
        user["lName"] = lName
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                
                KnockKnockUtils.okAlert(controller, title: "Error!", message: String(errorString!), handle: nil)
                // Show the errorString somewhere and let the user try again.
            } else {
                KnockKnockUtils.okAlert(controller, title: "Sign up success!", message: "Welcome " + fName, handle: { (action:UIAlertAction!) in
                    KnockKnockUtils.storyBoardCall(controller, story: "Profile", animated: true, view:"profilePic")})
            }
        }
    }
    
    // Update Profile Image
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
    
    // Current User
    static func currentUser() -> PFUser {
        return PFUser.currentUser()!
    }
    
    // Update user Details
    static func updateUser(controller: UIViewController, email: String, dob: NSDate, contact: Int){
        SwiftSpinner.show("Saving...")
        let user = PFUser.currentUser()
        
        user!.email = email
        user!["dob"] = dob
        user!["contact"] = contact
        
        user!.saveInBackgroundWithBlock{
            (succeeded: Bool, error: NSError?) -> Void in
            SwiftSpinner.hide()
        
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                
                KnockKnockUtils.okAlert(controller, title: "Error!", message: String(errorString!), handle: nil)
                // Show the errorString somewhere and let the user try again.
            } else {
                KnockKnockUtils.okAlert(controller, title: "Sign up success!", message: "Success!", handle: { (action:UIAlertAction!) in
                    KnockKnockUtils.storyBoardCall(controller, story: "Profile", animated: true, view:"profile")})
            }
            
        }

    }
    
}

