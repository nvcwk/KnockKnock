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
        SwiftSpinner.show("Logging out....")
        
        PFUser.logOutInBackgroundWithBlock( { (error: NSError?) -> Void in
            SwiftSpinner.hide()
            
            if( error == nil) {
                KnockKnockUtils.storyBoardCall(controller, story: "Credential", animated: true)
            }
        })
    }

}

