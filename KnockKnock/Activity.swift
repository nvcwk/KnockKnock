//
//  Activity.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 21/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import Foundation

class Activity {
    var title = ""
    var day = 0
    var description = ""
    //var cor : CLLocationCoordinate2D?
    var meetingTime = NSDate()
    var address = ""
    var isCompleted = false
    
    var cordinatesText = ""
    
    init() {
        title = ""
        day = 0
        description = ""
        //cor = CLLocationCoordinate2D()
        meetingTime = NSDate()
        address = ""
        
        cordinatesText = ""
        isCompleted = false
    }
}
