//
//  MarketPlaceV2ViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 16/1/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit

class MarketPlaceV2ViewController: UIViewController {
    
    @IBOutlet weak var view_container: UIView!
    
    var test = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
