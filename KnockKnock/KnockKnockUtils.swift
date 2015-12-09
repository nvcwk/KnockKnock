//
//  StoryBoardCalls.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse

class KnockKnockUtils {
    
    static func storyBoardCall(controller: UIViewController, story: String, animated: Bool) {
        let viewController : UIViewController = UIStoryboard(name: story, bundle: nil).instantiateInitialViewController()!
        
        controller.presentViewController(viewController, animated: animated, completion: nil)
    }
    
    static func okAlert(controller: UIViewController, title: String, message: String, handle: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: handle)
        
        alertController.addAction(OKAction)
        
        controller.presentViewController(alertController, animated: true, completion:nil)
    }
    
    static func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        return formatter.stringFromDate(date)
    }

}

