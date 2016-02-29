//
//  ChatViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 29/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Firebase
import Parse
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var messages = [JSQMessage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.downloadNewestMessagesFromParse()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
}

extension ChatViewController {
    
    func setup() {
        self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
       //self.channel.delegate = self
        //self.channel.subscribeToChannel()
    }
}

extension ChatViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}

extension ChatViewController {
    
    func sendMessageToParse(message: JSQMessage) {
        let messageToSend = Message()
        messageToSend.text = message.text
        messageToSend.senderId = self.senderId
        //messageToSend.channel = syncanoChannelName
        //messageToSend.other_permissions = .Full
        messageToSend.saveInBackground()
    }
    
    func downloadNewestMessagesFromParse() {
        let query1 = PFQuery(className: "Message")
        let query2 = PFQuery(className: "Message")
        //query.whereKey("sender", greaterThan: endDate)
        query1.whereKey("Sender", equalTo: PFUser.currentUser()!)
        query2.whereKey("Receiver", equalTo: PFUser.currentUser()!)
        
       let query = PFQuery.orQueryWithSubqueries([query1, query2])
        
        query.findObjectsInBackgroundWithBlock {
            (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let messages = messages as! [Message]!{
                    //for message in messages {
                        self.messages = self.jsqMessagesFromParseMessages(messages)
                        self.finishReceivingMessage()
                    //}
                }
            }else{
                //log details of the failure
                print("error: \(error!)  \(error!.userInfo)")
            }
        }

    }
    
    func jsqMessageFromParseMessage(message: Message) -> JSQMessage {
        let jsqMessage = JSQMessage(senderId: message.senderId, senderDisplayName: message.senderId, date: message.createdAt, text: message.text)
        return jsqMessage
    }
    
    func jsqMessagesFromParseMessages(messages: [Message]) -> [JSQMessage] {
        var jsqMessages : [JSQMessage] = []
        for message in messages {
            jsqMessages.append(self.jsqMessageFromParseMessage(message))
        }
        return jsqMessages
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages += [message]
        self.sendMessageToParse(message)
        self.finishSendingMessage()
    }
}



