//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/13/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    var businesses: [Business]!
    var lastSearchTerm = "Restaurants"
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        Business.searchWithTerm(lastSearchTerm, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
        
        searchBar.text = lastSearchTerm
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessCell
        
        cell.nameLabel.text = nil
        cell.distanceLabel.text = nil
        cell.reviewsCountLabel.text = nil
        cell.priceLabel.text = nil
        cell.addressLabel.text = nil
        cell.categoriesLabel.text = nil
        cell.thumbImageView.image = nil
        cell.ratingImageView.image = nil
        
        cell.row = indexPath.row
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
            }
        }
    }
}
