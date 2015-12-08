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
            StoryBoardCalls.call(controller, story: "Credential")
        }
        else {
            StoryBoardCalls.call(controller, story: "Main")
        }
    }
    
    static func logout(controller: UIViewController) {
        SwiftSpinner.show("Logging out....")
        
        PFUser.logOutInBackgroundWithBlock( { (error: NSError?) -> Void in
            
            if( error == nil) {
                SwiftSpinner.hide()
            
                StoryBoardCalls.call(controller, story: "Credential")
            }
        })
    }

}

