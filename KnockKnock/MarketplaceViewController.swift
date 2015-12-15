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
import ParseUI

class MarketplaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var headerArray = [String]()
    var priceArray = [Int]()
    var picArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "MarketPlace")
        let runkey = query.orderByAscending("title")
        runkey.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
        
        if error == nil{
            if let objects = objects as [PFObject]!{
                for object in objects {
                    
                    let header = object.objectForKey("title") as! String
                    let price = object.objectForKey("price") as! Int
                    let tourImageFile = object.objectForKey("image") as! PFFile
                    self.headerArray.append(header)
                    self.priceArray.append(price)
                    self.picArray.append(tourImageFile)
                    print(self.picArray)
                }
            }
            
        }else{
            //log details of the failure
            print("error: \(error!)  \(error!.userInfo)")
            }
        }
        //reload uiviewcontroller && tableview
        sleep(3)
        
        do_table_refresh()
    }

    func do_table_refresh(){
        dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()}
        )
        return
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
        return headerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MarketplaceTableViewCell
        let imageFile = picArray[indexPath.row]
        cell.headerLabel.text = self.headerArray[indexPath.row]
        cell.priceLabel.text = String(self.priceArray[indexPath.row]) + " /pax"
        
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
        if (error == nil) {
            cell.imageLabel.image = UIImage(data:imageData!)
            }
        }
        
        
        // cell.imageLabel.file = imageFile
        //cell.imageLabel.loadInBackground()
        
        
        //cell.imageLabel.file = imageFile
        //cell.imageLabel.loadInBackground()
        
        /*
        if let tourImageFile = object?["image"] as? PFFile {
            cell?.tourImage.file = tourImageFile
            cell?.tourImage.loadInBackground()
        }

        */
        return cell
    }
}
