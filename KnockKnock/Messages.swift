//
//  Messages.swift
//  KnockKnock
//
//  Created by Don Teo on 29/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import Foundation
import Parse
import Foundation

class Messages {
    
    class func startPrivateChat(user1: PFUser, user2: PFUser) -> String {
        let id1 = user1.objectId
        let id2 = user2.objectId
        
        let groupId = (id1 < id2) ? "\(id1)\(id2)" : "\(id2)\(id1)"
        
        createMessageItem(user1, groupId: groupId, description: user2.objectForKey("fName") as! String)
        createMessageItem(user2, groupId: groupId, description: user1.objectForKey("fName") as! String)
        
        return groupId
    }
    
    class func startMultipleChat(users: [PFUser]!) -> String {
        var groupId = ""
        var description = ""
        
        var userIds = [String]()
        
        for user in users {
            userIds.append(user.objectId!)
        }
        
        let sorted = userIds.sort()
        
        for userId in sorted {
            groupId = groupId + userId
        }
        
        for user in users {
            if description.characters.count > 0 {
                description = description + " & "
            }
            description = description + (user.objectForKey("fName") as! String)
        }
        
        for user in users {
            Messages.createMessageItem(user, groupId: groupId, description: description)
        }
        
        return groupId
    }
    
    class func createMessageItem(user: PFUser, groupId: String, description: String) {
        var query = PFQuery(className: "Message")
        query.whereKey("User", equalTo: user)
        query.whereKey("GroupID", equalTo: groupId)
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    var message = PFObject(className: "Message")
                    message["User"] = user;
                    message["GroupID"] = groupId;
                    message["MsgDescription"] = description;
                    message["LastUser"] = PFUser.currentUser()
                    message["LastMessage"] = "";
                    message["Counter"] = 0
                    message["Update"] = NSDate()
                    message.saveInBackgroundWithBlock{
                        (succeeded: Bool, error: NSError?) -> Void in
                        if (error != nil) {
                            print("Messages.createMessageItem save error.")
                            print(error)
                        }
                    }
                }
            } else {
                print("Messages.createMessageItem save error.")
                print(error)
            }
        }
    }
    
    class func deleteMessageItem(message: PFObject) {
        message.deleteInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("UpdateMessageCounter save error.")
                print(error)
            }
        }
    }
    
    class func updateMessageCounter(groupId: String, lastMessage: String) {
        var query = PFQuery(className: "Message")
        query.whereKey("GroupID", equalTo: groupId)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for message in objects as! [PFObject]! {
                    var user = message.objectForKey("User") as! PFUser
                    if user.objectId != PFUser.currentUser()!.objectId {
                        message.incrementKey("Counter") // Increment by 1
                        message["LastUser"] = PFUser.currentUser()
                        message["LastMessage"] = lastMessage
                        message["Update"] = NSDate()
                        message.saveInBackgroundWithBlock{
                            (succeeded: Bool, error: NSError?) -> Void in
                            if error != nil {
                                print("UpdateMessageCounter save error.")
                                print(error)
                            }
                        }
                    }
                }
            } else {
                print("UpdateMessageCounter save error.")
                print(error)
            }
        }
    }
    
    class func clearMessageCounter(groupId: String) {
        var query = PFQuery(className: "Message")
        query.whereKey("GroupID", equalTo: groupId)
        query.whereKey("User", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for message in objects as! [PFObject]! {
                    message["Counter"] = 0
                    message.saveInBackgroundWithBlock
                        { (succeeded: Bool, error: NSError?) -> Void in
                        if error != nil {
                            print("ClearMessageCounter save error.")
                            print(error)
                        }
                    }
                }
            } else {
                print("ClearMessageCounter save error.")
                print(error)
            }
        }
    }
    
}
