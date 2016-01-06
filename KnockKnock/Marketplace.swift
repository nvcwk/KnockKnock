//
//  Marketplace.swift
//  KnockKnock
//
//  Created by Don Teo on 15/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import Foundation

class MarketPlace {
    var price: Int {
        get {
            return self.price
        }
        
        set {
            self.price = newValue
        }
    }
    
    var tourPic: String {
        get {
            return self.tourPic
        }
        
        set {
            self.tourPic = newValue
        }
    }
    
    var summary: String {
        get {
            return self.summary
        }
        
        set {
            self.summary = newValue
        }
    }
    
    var tour: String {
        get {
            return self.tour
        }
        
        set {
            self.tour = newValue
        }
    }
}