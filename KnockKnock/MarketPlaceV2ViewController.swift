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
import Popover

class MarketPlaceV2ViewController: UIViewController {

    @IBOutlet weak var btn_sortby: UIButton!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var view_container: UIView!
    
    var popover_show = Popover()
    var popover_filter = Popover()
    
    private var popoverOptions: [PopoverOption] = [
        .Type(.Down),
        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    
    @IBAction func dismiss_pop(sender: AnyObject) {
        popover_filter.dismiss()
        popover_show.dismiss()
    }
    var test = true
    
    var clicked_button = false
    
    private var texts_sortby = ["Highest to Lowest Price", "Lowest to Highest Price", "Earliest Start Date"]

    
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
    
    @IBAction func sortv1_Press(sender: AnyObject) {
        
        //clicked_button = true
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 140))
        
        let startPoint = CGPoint(x: self.view.frame.width/2 , y: 100)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.popover_show = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
        
        //var popover = Popover()
        self.popover_show.show(tableView, point: startPoint)
        
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
        
        var applyButton : UIBarButtonItem = UIBarButtonItem(title: "Apply Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        
        lgVC.navigationItem.rightBarButtonItem = applyButton
        applyButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], forState: UIControlState.Normal)
        
        var clearButton : UIBarButtonItem = UIBarButtonItem(title: "Reset Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        lgVC.navigationItem.leftBarButtonItem = clearButton
        clearButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], forState: UIControlState.Normal)
        
        
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

extension MarketPlaceV2ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.popover_show.dismiss()
        clicked_button = false
        
        var controller = self.childViewControllers[0] as! MarketPlaceV2TableViewController
        controller.sort = indexPath.row
        controller.loadObjects()
        controller.viewWillAppear(true)
    }
}

extension MarketPlaceV2ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //        if(clicked_button == true){
        return texts_sortby.count
        //        } else {
        //            return 1
        //        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts_sortby[indexPath.row]
        return cell
    }
}

