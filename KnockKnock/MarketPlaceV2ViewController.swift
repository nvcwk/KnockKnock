//
//  MarketPlaceV2ViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 16/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import QIULaunchAnimation
import autoAutoLayout
import Parse
import LGSemiModalNavController

class MarketPlaceV2ViewController: UIViewController {

    @IBOutlet weak var btn_sortby: UIButton!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var view_container: UIView!

    
    //@IBOutlet weak var leftBottomButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

       // KnockKnockUtils.updateUserRating(PFUser.currentUser()!)

                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        ParseUtils.checkLogin(self)
        
        self.view!.removeConstraints(self.view.constraints)
        AutoAutoLayout.layoutFromBaseModel("6", forSubviewsOf: self.view!)
        
        // Do any additional setup after loading the view.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func on_Press(sender: AnyObject) {
        var lgVC = UIViewController();
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MarketPlace", bundle: nil )
        
        lgVC = storyboard.instantiateViewControllerWithIdentifier("SortViewController")
        
        var semiModal: LGSemiModalNavViewController = LGSemiModalNavViewController(rootViewController: lgVC)
        lgVC.navigationItem.title = "Sort By: "
//        var applyButton : UIBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "")
//        lgVC.navigationItem.rightBarButtonItem = applyButton
        lgVC.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!]
        
        
        semiModal.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 275)
        semiModal.backgroundShadeColor = UIColor.darkGrayColor()
        semiModal.animationSpeed = 0.35
        semiModal.tapDismissEnabled = true
        semiModal.backgroundShadeAlpha = 0.3
        semiModal.scaleTransform = CGAffineTransformMakeScale(1.0, 1.0)
        semiModal.view.backgroundColor = UIColor.whiteColor()
        
        self.presentViewController(semiModal, animated: true, completion: { _ in })
        
    }
    @IBAction func on_Press_filter(sender: AnyObject) {
        var lgVC = UIViewController();
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MarketPlace", bundle: nil )
        
        lgVC = storyboard.instantiateViewControllerWithIdentifier("FilterViewController")
        
        var semiModal: LGSemiModalNavViewController = LGSemiModalNavViewController(rootViewController: lgVC)
        lgVC.navigationItem.title = "Filter By: "
        lgVC.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!]
        
        var applyButton : UIBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        
        lgVC.navigationItem.rightBarButtonItem = applyButton
        applyButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], forState: UIControlState.Normal)
        
        semiModal.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300)
        semiModal.backgroundShadeColor = UIColor.darkGrayColor()
        semiModal.animationSpeed = 0.35
        semiModal.tapDismissEnabled = true
        semiModal.backgroundShadeAlpha = 0.3
        semiModal.scaleTransform = CGAffineTransformMakeScale(1.0, 1.0)
        semiModal.view.backgroundColor = UIColor.whiteColor()
        
        self.presentViewController(semiModal, animated: true, completion: { _ in })
    }

    
}

