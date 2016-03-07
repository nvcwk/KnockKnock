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
//import Popover

class MarketPlaceV2ViewController: UIViewController {

    @IBOutlet weak var btn_sortby: UIButton!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var view_container: UIView!
    
//    var popover_show = Popover()
//    var popover_filter = Popover()
//    
//    private var popoverOptions: [PopoverOption] = [
//        .Type(.Down),
//        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
//    ]
//    
    var sortVC = SortTableViewController();
    var filterVC = FilterTableViewController();
    
//    @IBAction func dismiss_pop(sender: AnyObject) {
//        popover_filter.dismiss()
//        popover_show.dismiss()
//    }
//    var test = true
//    
//    var clicked_button = false
    
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
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MarketPlace", bundle: nil )
        
        sortVC = storyboard.instantiateViewControllerWithIdentifier("SortViewController") as! SortTableViewController
        filterVC = storyboard.instantiateViewControllerWithIdentifier("FilterViewController") as! FilterTableViewController
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sortv1_Press(sender: AnyObject) {
        
        //clicked_button = true
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 140))
        
        let startPoint = CGPoint(x: self.view.frame.width/2 , y: 100)
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.scrollEnabled = false
//        self.popover_show = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
//        
//        //var popover = Popover()
//        self.popover_show.show(tableView, point: startPoint)
        
    }
    
    
    @IBAction func on_Press(sender: AnyObject) {
        var semiModal: LGSemiModalNavViewController = LGSemiModalNavViewController(rootViewController: sortVC)
        sortVC.navigationItem.title = "Sort By: "
        var applyButton : UIBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "applySort:")
        sortVC.navigationItem.rightBarButtonItem = applyButton
        sortVC.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!]
        
        
        semiModal.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 225)
        semiModal.backgroundShadeColor = UIColor.darkGrayColor()
        semiModal.animationSpeed = 0.35
        semiModal.tapDismissEnabled = true
        semiModal.backgroundShadeAlpha = 0.3
        semiModal.scaleTransform = CGAffineTransformMakeScale(1.0, 1.0)
        semiModal.view.backgroundColor = UIColor.whiteColor()
        
        self.presentViewController(semiModal, animated: true, completion: { _ in })
        
    }
    
    @IBAction func applyReset(sender: AnyObject) {
        filterVC.startDate = 1.years.ago()
        filterVC.endDate = 5.years.fromNow()
        filterVC.days = 5
        filterVC.minPrice = 0
        filterVC.maxPrice = 999
        
        filterVC.tf_minPrice.text = String(filterVC.minPrice)
        filterVC.tf_maxPrice.text = String(filterVC.maxPrice)
        filterVC.tf_startDate.text = KnockKnockUtils.dateToStringDisplay(filterVC.startDate)
        filterVC.tf_endDate.text = KnockKnockUtils.dateToStringDisplay(filterVC.endDate)
        filterVC.ctrl_days.selectedSegmentIndex = filterVC.days
        
        var controller = self.childViewControllers[0] as! MarketPlaceV2TableViewController
        controller.days = filterVC.days
        controller.minPrice = filterVC.minPrice
        controller.maxPrice = filterVC.maxPrice
        controller.startDate = filterVC.startDate
        controller.endDate = filterVC.endDate
        controller.loadObjects()
        controller.viewWillAppear(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func applySort(sender: AnyObject) {        
        var controller = self.childViewControllers[0] as! MarketPlaceV2TableViewController
        controller.ascending = sortVC.ascending
        controller.sort = sortVC.selected
        controller.loadObjects()
        controller.viewWillAppear(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func applyFilter(sender: AnyObject) {
        if(filterVC.tf_minPrice.text!.isEmpty) {
            filterVC.tf_minPrice.text = String(0)
        }
        
        if(filterVC.tf_maxPrice.text!.isEmpty) {
            filterVC.tf_maxPrice.text = String(999)
        }
        
        var controller = self.childViewControllers[0] as! MarketPlaceV2TableViewController
        controller.days = filterVC.days
        controller.minPrice = filterVC.minPrice
        controller.maxPrice = filterVC.maxPrice
        controller.startDate = filterVC.startDate
        controller.endDate = filterVC.endDate
        controller.loadObjects()
        controller.viewWillAppear(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func on_Press_filter(sender: AnyObject) {
        var semiModal: LGSemiModalNavViewController = LGSemiModalNavViewController(rootViewController: filterVC)
        filterVC.navigationItem.title = "Filter By: "
        filterVC.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!]
        
        var applyButton : UIBarButtonItem = UIBarButtonItem(title: "Apply Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "applyFilter:")
        
        filterVC.navigationItem.rightBarButtonItem = applyButton
        applyButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], forState: UIControlState.Normal)
        
        var clearButton : UIBarButtonItem = UIBarButtonItem(title: "Reset Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "applyReset:")
        filterVC.navigationItem.leftBarButtonItem = clearButton
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
//
//extension MarketPlaceV2ViewController: UITableViewDelegate {
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.popover_show.dismiss()
//        clicked_button = false
//        
//        var controller = self.childViewControllers[0] as! MarketPlaceV2TableViewController
//        controller.sort = indexPath.row
//        controller.loadObjects()
//        controller.viewWillAppear(true)
//    }
//}

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

