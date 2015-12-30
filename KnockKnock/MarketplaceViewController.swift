
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
    var selectedEndDate = 5.days.fromDate(NSDate())
    var selectedStartDate = 5.days.fromDate(NSDate())
    
    
    var searchActive : Bool = false
    
    var filteredMarketplaceArray = [PFObject]()
    
    var sort = false

    var marketplaceArray = [PFObject]()

    //@IBOutlet weak var placeholderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialDate = convertDateFormat(NSDate())

        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = 5.days.fromDate(NSDate())
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_startDate.inputView = startDatePicker
        tf_startDate.text = initialDate
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = 5.days.fromDate(NSDate())
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_endDate.inputView = endDatePicker
        tf_endDate.text = initialDate
        
        
        searchBar.delegate = self
        
        
        
        callingParse(sort)

        
        //reload uiviewcontroller && tableview
        sleep(3)
        
        do_table_refresh()
    }
    
    // Calling Parse DB
    func callingParse(sort : Bool){
        
        let today = NSDate()

        
       /* self.headerArray.removeAll()
        self.priceArray.removeAll()
        self.picArray.removeAll()
        self.summaryArray.removeAll()
        self.hostArray.removeAll()
        self.marketplaceArray.removeAll()
        */
        
        // This query calls for the listing in the marketplace and validate the date (lastavailabledate < today's date)
        let query = PFQuery(className: "MarketPlace")
        query.whereKey("lastAvailability", greaterThan: today)
        query.includeKey("itinerary")
        query.includeKey("host")
        query.includeKey("activities")
        

        
        
        if sort{
            query.orderByAscending("price")
        }
        else{
            query.orderByAscending("title")
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects = objects as [PFObject]!{
                    for object in objects {
                        
                        self.marketplaceArray.append(object)

                    }
                }
                
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
        if(searchActive){
            let filteredMarketplaceObject = filteredMarketplaceArray[indexPath.row]
            title = filteredMarketplaceObject["itinerary"].objectForKey("title") as? String
            price = filteredMarketplaceObject.objectForKey("price") as! Int
            image = filteredMarketplaceObject["itinerary"].objectForKey("image")! as! PFFile

        } else {
            let marketplaceObject = marketplaceArray[indexPath.row]
            title = marketplaceObject["itinerary"].objectForKey("title") as? String
            price = marketplaceArray[indexPath.row].objectForKey("price") as! Int
            image = marketplaceObject["itinerary"].objectForKey("image")! as! PFFile
        }
        
        
        image.getDataInBackgroundWithBlock({
            (result, error) in
            cell.imageLabel.image = UIImage(data: result!)
        })
        
        
        cell.priceLabel.text = "S$" + String(price) + "/pax"
        
        cell.headerLabel?.text = title

        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let detailedController: DetailedMarketplaceViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailedMarketplaceViewController") as! DetailedMarketplaceViewController
//        let currentObject : PFObject
//        currentObject = filteredMarketplaceArray[indexPath.row]
//       let itinerary = currentObject.objectForKey("itinerary") as! PFObject
//        
//        let iti : PFObject
//        
//        let query2 = PFQuery(className: "Itinerary")
//        do {
//            iti = try query2.getObjectWithId(itinerary.objectId as String!)
//            // load image
//            let imageFile = iti.objectForKey("image") as! PFFile
//            detailedController.picFile = imageFile
//            //load host
//            let host = currentObject.objectForKey("host") as! PFUser
//            
//            detailedController.host = host
//            //load header
//            detailedController.header = currentObject.objectForKey("title") as! String
//            //load price
//            detailedController.price = String(currentObject.objectForKey("price") as! Int)
//            //load activites 
//            let list = iti.objectForKey("activities") as! NSArray
//            detailedController.activities = list
//            //load iti/current object
//            detailedController.currentObject = iti as! PFObject
//        } catch is ErrorType {
//            print("Invalid Selection.")
//        }
//        
//        
//        self.presentViewController(detailedController, animated: true, completion: nil)
//    }
    
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
        sort = true
        viewDidLoad()
    }
    
    
    
    //Sort by date tf
    
    //Convert date format to dd/MM/yyyy for easier display in the tf
    func convertDateFormat(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let convertedDate = dateFormatter.stringFromDate(date)
        
        return convertedDate
    }
    
    func updateStartDate(sender: UIDatePicker) {
        
        let convertedDate = convertDateFormat(sender.date)
        
        tf_startDate.text = convertedDate
        
        endDatePicker.minimumDate = sender.date
        
        if(selectedEndDate < sender.date) {
            tf_endDate.text = ""
        }
    
    }
    
    func updateEndDate(sender: UIDatePicker) {
        
        let convertedDate = convertDateFormat(sender.date)
        
        tf_endDate.text = convertedDate
        
        selectedEndDate = sender.date
        
    }
}
