//
//  SortTableViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 21/2/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    var ascending = true
    var selected = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 1, inSection: 0);
        self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect);
        
    }

    @IBAction func actionChangeSortOrder(sender: UISegmentedControl) {
        if(ascending) {
            ascending = false
        } else {
            ascending = true
        }
        
        print(ascending)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath == 0) {
            
        }
        selected = indexPath.row
    }
}
