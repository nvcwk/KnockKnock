//
//  MarketplaceViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 15/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit
import PassKit
import Parse
import Bolts

class MarketplaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var testArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testArray = ["1", "2", "3"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return testArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MarketplaceTableViewCell
        cell.headerLabel.text = self.testArray[indexPath.row]
        return cell
    }
}
