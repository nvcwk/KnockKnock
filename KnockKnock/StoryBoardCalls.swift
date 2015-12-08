//
//  StoryBoardCalls.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 8/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import Parse

class StoryBoardCalls {
    
    static func call(controller : UIViewController, story : String) {
        var viewController : UIViewController = UIStoryboard(name: story, bundle: nil).instantiateInitialViewController()!
        
        controller.presentViewController(viewController, animated: true, completion: nil)
    }
}

