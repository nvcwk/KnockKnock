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
import SwiftDate
import GMStepper
import CoreData


class MarketplaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tf_startDate: UITextField!
    @IBOutlet weak var tf_endDate: UITextField!
    
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var selectedEndDate = NSDate()
    var selectedStartDate = NSDate()
    
    var header : String!
    
    var searchActive : Bool = false
    
    var filteredMarketplaceArray = [PFObject]()
    
    
    var sortByPriceDesc = false
    
    var marketplaceArray = [PFObject]()
    
    var sortByPrice = false
    
    var sortByStartDate = false
    
    var today = NSDate()
    
    var sortByEndDate = false
    
    var endDate = NSDate()
    
    var dateSet = [NSDate]()
    
    //@IBOutlet weak var placeholderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialDate = KnockKnockUtils.dateToString(NSDate())
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = NSDate()
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_startDate.inputView = startDatePicker
        tf_startDate.text = initialDate
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = NSDate()
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_endDate.inputView = endDatePicker
        tf_endDate.text = initialDate
        
        
        searchBar.delegate = self
        
        
        
        callingParse(sortByPrice, sortByStartDate: sortByStartDate, sortByEndDate: sortByEndDate)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        //reload uiviewcontroller && tableview
        sleep(3)
        
        do_table_refresh()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        callingParse(sortByPrice, sortByStartDate: sortByStartDate, sortByEndDate: sortByEndDate)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    // Calling Parse DB
    func callingParse(sortByPrice : Bool, sortByStartDate : Bool, sortByEndDate : Bool){
        
        
        filteredMarketplaceArray.removeAll()
        marketplaceArray.removeAll()
        
        
        // This query calls for the listing in the marketplace and validate the date (lastavailabledate < today's date)
        let query = PFQuery(className: "MarketPlace")
        
        query.includeKey("itinerary")
        query.includeKey("host")
        query.includeKey("activities")
        
        query.whereKey("isPublished", equalTo: true)
        
        query.whereKey("lastAvailability", greaterThan: today)
        query.whereKey("startAvailability", lessThan: endDate)
        
        if sortByPrice{
            if sortByPriceDesc{
                query.orderByDescending("price")
            }else{
                query.orderByAscending("price")
            }
        }
        
        
        if sortByStartDate{
            query.whereKey("lastAvailability", greaterThan: today)
            //query.whereKey("lastAvailability", greaterThan: today)
        }
        if sortByEndDate{
            query.whereKey("lastAvailability", greaterThan: today)
            query.whereKey("startAvailability", lessThan: endDate)
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects = objects as [PFObject]!{
                    for object in objects {
                        
                        self.marketplaceArray.append(object)
                        
                        
                    }
                }
                self.tableView.reloadData()
            }else{
                //log details of the failure
                print("error: \(error!)  \(error!.userInfo)")
            }
        }
    }
    
    func do_table_refresh(){
        dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
        return
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    // Tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(searchActive) {
            return filteredMarketplaceArray.count
        }
        return marketplaceArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MarketplaceTableViewCell
        let price : Int
        let image : PFFile
        let title1 : String
        if(searchActive){
            let filteredMarketplaceObject = filteredMarketplaceArray[indexPath.row]
            title1 = (filteredMarketplaceObject["itinerary"].objectForKey("title") as? String)!
            price = filteredMarketplaceObject.objectForKey("price") as! Int
            image = filteredMarketplaceObject["itinerary"].objectForKey("image")! as! PFFile
            
        } else {
            var marketplaceObject = marketplaceArray[indexPath.row]
            title1 = (marketplaceObject["itinerary"].objectForKey("title") as? String)!
            price = marketplaceArray[indexPath.row].objectForKey("price") as! Int
            image = marketplaceObject["itinerary"].objectForKey("image")! as! PFFile
        }
        
        cell.imageLabel.file = image
        cell.imageLabel.loadInBackground()
        
        
//        image.getDataInBackgroundWithBlock({
//            (result, error) in
//            cell.imageLabel.image = UIImage(data: result!)
//        })
//        
        
        cell.priceLabel.text = "S$" + String(price) + "/pax"
        
        cell.headerLabel?.text = title1
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showExpandedView", sender: cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showExpandedView") {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                
                if let index = indexPath?.row {
                    let controller = segue.destinationViewController as! DetailedMarketplaceViewController
                    let cellObject : PFObject
                    
                    if !searchActive || filteredMarketplaceArray.isEmpty{
                        cellObject = marketplaceArray[index]
                    }else{
                        cellObject = filteredMarketplaceArray[index]
                        
                    }
                    
                    controller.currentObject = cellObject
                    
                }
            }
        }
    }
    
    
    
    
    // Search engine
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    //lacking of zero data
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMarketplaceArray = marketplaceArray.filter({ (object) -> Bool in
            let tmp: NSString = object["itinerary"].objectForKey("title") as! NSString
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredMarketplaceArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredMarketplaceArray = marketplaceArray.filter { marketplace in
            return marketplace.objectForKey("title")!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    // Sort by Price btn
    @IBAction func sortByPrice(sender: AnyObject) {
        sortByPrice = true
        sortByPriceDesc = false
        callingParse(sortByPrice, sortByStartDate: sortByStartDate, sortByEndDate: sortByEndDate)
    }
    
    @IBAction func sortByPriceDesc(sender: AnyObject) {
        sortByPrice = true
        sortByPriceDesc = true
        callingParse(sortByPrice, sortByStartDate: sortByStartDate, sortByEndDate: sortByEndDate)
    }
    
    
    
    
    
    //Sort by date tf
    
    func updateStartDate(sender: UIDatePicker) {
        
        let convertedDate = KnockKnockUtils.dateToString(sender.date)
        
        tf_startDate.text = convertedDate
        
        endDatePicker.minimumDate = sender.date
        
        if(selectedEndDate < sender.date) {
            tf_endDate.text = ""
        }
        
        today = KnockKnockUtils.StringToDate(convertedDate)
        
        endDate = KnockKnockUtils.StringToDate(convertedDate)
        
        sortByStartDate = true
        
        sortByEndDate = false
        
        
        callingParse(sortByPrice, sortByStartDate: sortByStartDate, sortByEndDate: sortByEndDate)
        
        
    }
    
    func updateEndDate(sender: UIDatePicker) {
        
        let convertedDate = KnockKnockUtils.dateToString(sender.date)
        
        tf_endDate.text = convertedDate
        
        selectedEndDate = sender.date
        
        endDate = KnockKnockUtils.StringToDate(convertedDate)
        
        sortByStartDate = false
        sortByEndDate = true
        
        callingParse(sortByPrice, sortByStartDate: sortByStartDate, sortByEndDate: sortByEndDate)
        
        
    }
    
    
}
