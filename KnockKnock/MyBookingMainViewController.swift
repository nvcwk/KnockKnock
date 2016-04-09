//
//  MyBookingMainViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 14/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import autoAutoLayout

class MyBookingMainViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    
    var controller1 : PendingTableViewViewController?
    var controller2 : ConfirmedTableViewController?
    var controller3 : CancelledTableViewController?
    
    func loadPending(notification: NSNotification){
        //load data here
        setup()
        pageMenu?.moveToPage(0)
    }
    
    func loadConfirm(notification: NSNotification) {
        setup()
        pageMenu?.moveToPage(1)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadPending:",name:"loadPending", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadConfirm:",name:"loadConfirm", object: nil)
        
        setup()
    }
    
    func setup() {
        var controllerArray : [UIViewController] = []
        var parameters: [CAPSPageMenuOption]?
        
        controller1 = PendingTableViewViewController(nibName: "PendingTableViewViewController", bundle: nil)
        controller1!.title = "Requests"
        controller1!.parentNaviController = self.navigationController!
        controllerArray.append(controller1!)
        
        controller2 = ConfirmedTableViewController(nibName: "ConfirmedTableViewController", bundle: nil)
        controller2!.title = "Bookings"
        controller2!.parentNaviController = self.navigationController!
        controllerArray.append(controller2!)
        
        controller3 = CancelledTableViewController(nibName: "CancelledTableViewController", bundle: nil)
        controller3!.title = "Cancelled"
        controller3!.parentNaviController = self.navigationController!
        controllerArray.append(controller3!)
        
        parameters = [
            .MenuItemSeparatorWidth(4.3),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
            .SelectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .MenuMargin(20.0),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(true),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        let navheight = (navigationController?.navigationBar.frame.size.height ?? 0) + UIApplication.sharedApplication().statusBarFrame.size.height
        
        let frameHeight = self.tabBarController!.tabBar.frame.height + navheight
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, navheight, self.view.frame.width, self.view.frame.height - frameHeight), pageMenuOptions: parameters)
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        //print("NIC: " + String(view.subviews.count))
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
    }
    
    @IBAction func backItinerary(segue:UIStoryboardSegue) {
    }
    
    
}
