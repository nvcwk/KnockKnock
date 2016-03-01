//
//  SelectSingleViewController.swift
//  KnockKnock
//
//  Created by Don Teo on 1/3/16.
//  Copyright © 2016 Gen6. All rights reserved.
//

import UIKit
import Parse


protocol SelectSingleViewControllerDelegate {
    func didSelectSingleUser(user: PFUser)
}

class SelectSingleViewController: UITableViewController, UISearchBarDelegate {
    
    var users = [PFUser]()
    var delegate: SelectSingleViewControllerDelegate!
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       // self.searchBar.delegate = self
        self.loadUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Backend methods
    
    func loadUsers() {
        let user = PFUser.currentUser()
        var query = PFQuery(className: "User")
        query.whereKey("objectId", notEqualTo:user!.objectId!)
        query.orderByAscending("fName")
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                //ProgressHUD.showError("Network error")
            }
        }
    }
    
    /*func searchUsers(searchLower: String) {
        let user = PFUser.currentUser()
        var query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey("objectId", notEqualTo: user.objectId)
        query.whereKey(PF_USER_FULLNAME_LOWER, containsString: searchLower)
        query.orderByAscending(PF_USER_FULLNAME)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
            }
            
        }
    }*/
    
    // MARK: - User actions
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.objectForKey("fName") as? String
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if self.delegate != nil {
                self.delegate.didSelectSingleUser(self.users[indexPath.row])
            }
        })
    }
    
    // MARK: - UISearchBar Delegate
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 0 {
            self.searchUsers(searchText.lowercaseString)
        } else {
            self.loadUsers()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBarCancelled()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelled() {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        
        self.loadUsers()
    }
    
}*/


}
