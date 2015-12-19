//
//  ItiActivitiesViewController.swift
//  KnockKnock
//
//  Created by Nicholas Chan on 19/12/15.
//  Copyright © 2015 Gen6. All rights reserved.
//

import UIKit

class ItiActivitiesViewController: UIViewController {
    
    let identifier = "daysIdentifier"
    var days = 3
    
    @IBOutlet weak var collection_days: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collection_days.dataSource = self
        collection_days.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toActivityView") {
            let controller = segue.destinationViewController as! ItiActivityViewController
            let temp = collection_days.indexPathsForSelectedItems()![0] as! NSIndexPath
            controller.day = temp.row + 1
        }
    }
    
    @IBAction func backActivities(segue:UIStoryboardSegue) {
        
    }
}

extension ItiActivitiesViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! DayCollectionViewCell
        
        cell.lb_day.text = "Day " + String(indexPath.row + 1)
        
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
}

extension ItiActivitiesViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //selected = indexPath.row
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

