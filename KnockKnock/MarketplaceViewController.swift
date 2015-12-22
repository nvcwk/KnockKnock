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
    
    var sort = false
    var headerArray = [String]()
    var filteredHeaderArray = [String]()
    var priceArray = [Int]()
    var picArray = [PFFile]()
    var hostArray = [PFObject]()
    var summaryArray = [String]()
    var marketplaceArray = [PFObject]()
    
    //@IBOutlet weak var placeholderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker.datePickerMode = UIDatePickerMode.Date
        startDatePicker.minimumDate = 5.days.fromDate(NSDate())
        startDatePicker.addTarget(self, action: Selector("updateStartDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_startDate.inputView = startDatePicker
        tf_startDate.text = KnockKnockUtils.dateToString(5.days.fromDate(NSDate()))
        
        endDatePicker.datePickerMode = UIDatePickerMode.Date
        endDatePicker.minimumDate = 5.days.fromDate(NSDate())
        endDatePicker.addTarget(self, action: Selector("updateEndDate:"),
            forControlEvents:UIControlEvents.ValueChanged)
        
        tf_endDate.inputView = endDatePicker
        tf_endDate.text = KnockKnockUtils.dateToString(5.days.fromDate(NSDate()))
    
        
        
        
        searchBar.delegate = self
        
        /*
        // todays date.
        let date = NSDate()
        
        // create an instance of calendar view with
        // base date (Calendar shows 12 months range from current base date)
        // selected date (marked dated in the calendar)
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(calendarView)
        
        // Constraints for calendar view - Fill the parent view.
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        */
        
        
        callingParse(sort)

        
        //reload uiviewcontroller && tableview
        sleep(3)
        
        do_table_refresh()
    }
    
    func updateStartDate(sender: UIDatePicker) {
        tf_startDate.text = KnockKnockUtils.dateToString(sender.date)
        
        endDatePicker.minimumDate = sender.date
        
        if(selectedEndDate < sender.date) {
            tf_endDate.text = ""
        }
    }
    
    func updateEndDate(sender: UIDatePicker) {
        tf_endDate.text = KnockKnockUtils.dateToString(sender.date)
        selectedEndDate = sender.date
    }

    @IBAction func sortByPrice(sender: AnyObject) {
        sort = true
        viewDidLoad()
    }
    
    func callingParse(sort : Bool){
        
        self.headerArray.removeAll()
        self.priceArray.removeAll()
        self.picArray.removeAll()
        self.summaryArray.removeAll()
        self.hostArray.removeAll()
        self.marketplaceArray.removeAll()
        
        let query = PFQuery(className: "MarketPlace")
        
        if sort
        {
            query.orderByAscending("price")
        }
        else
        {
        query.orderByAscending("title")
        }
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects = objects as [PFObject]!{
                    for object in objects {
                        
                        let header = object.objectForKey("title") as! String
                        let price = object.objectForKey("price") as! Int
                        let tourImageFile = object.objectForKey("image") as! PFFile
                        let summary = object.objectForKey("summary") as! String
                        let host = object.objectForKey("host") as! PFObject
                        self.headerArray.append(header)
                        self.priceArray.append(price)
                        self.picArray.append(tourImageFile)
                        self.summaryArray.append(summary)
                        self.hostArray.append(host)
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
        dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()}
        )
        return
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredHeaderArray = headerArray.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredHeaderArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    //tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(searchActive) {
            return filteredHeaderArray.count
        }
        return headerArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let imageFile = picArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MarketplaceTableViewCell
        let header: String
        
        
        if(searchActive){
            header = filteredHeaderArray[indexPath.row]
        } else {
            header = headerArray[indexPath.row];
        }
        
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                cell.imageLabel.image = UIImage(data:imageData!)
            }
        }
        
        cell.headerLabel?.text = header
        cell.priceLabel.text = "S$" + String(self.priceArray[indexPath.row]) + " /pax"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailedController: DetailedMarketplaceViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailedMarketplaceViewController") as! DetailedMarketplaceViewController
        
        let imageFile = picArray[indexPath.row]
        let host = hostArray[indexPath.row]
        let marketObject = marketplaceArray[indexPath.row]
        
        detailedController.header = headerArray[indexPath.row]
        detailedController.price = String(self.priceArray[indexPath.row])
        detailedController.host = host
        detailedController.summary = summaryArray[indexPath.row]
        detailedController.picFile = imageFile
        detailedController.currentObject = marketObject
        self.presentViewController(detailedController, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredHeaderArray = headerArray.filter { header in
            return header.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func sortByDate(sender: AnyObject) {

        

    }
    

    
}
