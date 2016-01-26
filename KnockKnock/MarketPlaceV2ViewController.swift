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
import Popover
import Parse

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
        
        var fadeAnimation: QIULaunchAnimationFade = QIULaunchAnimationFade()
        //fadeAnimation.animationDuration = 5;
        fadeAnimation.startAnimation(nil)

        // Do any additional setup after loading the view.
        
//        var customView = UIView(frame: CGRectMake(0, 0, 250, 44))
//        
//        var marginX = CGFloat(0)
//        var label = UILabel(frame: CGRectMake(marginX, 0, 250, 44))
//        label.text = "KnockKnock"
//        label.textColor = DPTheme.color(0x00A1B0, alpha: 1.0)
//        label.font = UIFont(name: "SnellRoundhand-Black", size: 25)
//        customView.addSubview(label)
//        
//        var leftButton = UIBarButtonItem(customView: customView)
//        self.navigationItem.leftBarButtonItem = leftButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func on_Press(sender: AnyObject) {
        
        clicked_button = true
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 140))
        
        let startPoint = CGPoint(x: self.view.frame.width / 2, y: 100)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.popover_show = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)

        //var popover = Popover()
        self.popover_show.show(tableView, point: startPoint)

    }
    @IBAction func on_Press_filter(sender: AnyObject) {
        let startPoint = CGPoint(x: self.view.frame.width - 80, y: 100)
//        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 180))
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 180))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.popover_show = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
        
        //var popover = Popover()
        self.popover_filter.show(tableView, point: startPoint)
    }
    
    @IBAction func actionTest(sender: UIButton) {
        
        if(test) {
            test = false
        } else {
            test = true
        }
        
        var tv = self.childViewControllers[0] as! MarketPlaceV2TableViewController
        tv.published = test
        tv.loadObjects()
        tv.viewWillAppear(true)
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
        if(clicked_button == true){
            return texts_sortby.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts_sortby[indexPath.row]
        return cell
    }
}
