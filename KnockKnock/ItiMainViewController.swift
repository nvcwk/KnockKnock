//
//  ItineraryViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 18/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import autoAutoLayout
import KBRoundedButton

class ItiMainViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    
    @IBOutlet weak var btn_add: KBRoundedButton!
    
    var controller1 : ItiTableViewController?
    var controller2 : PubTableViewController?

    func loadPublish(notification: NSNotification){
        //load data here
        setup()
        pageMenu?.moveToPage(1)
    }
    
    func loadItinerary(notification: NSNotification) {
        setup()
        pageMenu?.moveToPage(0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadPublish:", name:"loadPublish", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadItinerary:", name:"loadItinerary", object: nil)
        

        setup()
        self.view.bringSubviewToFront(btn_add)
        
    }
    
    func setup() {
        var controllerArray : [UIViewController] = []
        var parameters: [CAPSPageMenuOption]?
        
        controller1 = ItiTableViewController(nibName: "ItiTableViewController", bundle: nil)
        controller1!.title = "Itinerary"
        controller1!.parentNaviController = self.navigationController!
        controllerArray.append(controller1!)
        
        controller2 = PubTableViewController(nibName: "PubTableViewController", bundle: nil)
        controller2!.title = "Published"
        controller2!.parentNaviController = self.navigationController!
        controllerArray.append(controller2!)
        
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
        
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
    }

    @IBAction func backItinerary(segue:UIStoryboardSegue) {
    }

    func didMoveToPage(controller: UIViewController, index: Int){
        if(index == 1) {
            self.btn_add.hidden = true
        } else {
            self.btn_add.hidden = false
        }
    }
    
    
}