//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/13/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    enum ViewMode: String {
        case List = "List"
        case Map = "Map"
    }

    var searchBar: UISearchBar!
    
    let searchDefaultLimit = 20
    let searchDefaultOffset = 0
    var searchCurrentOffset = 0
    
    var businesses: [Business]!
    var lastSearchTerm = "Restaurants"
    var lastSearchFilters: [String: AnyObject]?
    var currentViewMode = ViewMode.List
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        let lastSearchTermSaved = NSUserDefaults.standardUserDefaults().objectForKey(Utils.LastSearchTerm) as? String
        lastSearchTerm = lastSearchTermSaved == nil ? lastSearchTerm : lastSearchTermSaved!
        
        if NSUserDefaults.standardUserDefaults().boolForKey(Utils.IsFiltered) {
            lastSearchFilters = Utils.sharedInstance.getLastSearchFilters()
            print("lastSearchFilters \(lastSearchFilters)")
            searchWithTerm(lastSearchTerm, limit: searchDefaultLimit, offset: searchDefaultOffset, filters: lastSearchFilters!)
        } else {
            searchWithTerm(lastSearchTerm, limit: searchDefaultLimit, offset: searchDefaultOffset)
        }
        searchBar.text = lastSearchTerm
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FiltersSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
        } else if segue.identifier == "BusinessDetailsSegue" {
            let indexPath = tableView.indexPathForSelectedRow!
            let businessDetailsViewController = segue.destinationViewController as! BusinessDetailsViewController
            businessDetailsViewController.business = businesses[indexPath.row]
        }
    }
    
    // MARK: - Search
    
    func searchWithTerm(term: String, limit: Int?, offset: Int?) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm(lastSearchTerm, limit: limit, offset: offset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.businesses = businesses
            self.tableView.reloadData()
            self.addAnnotationForBusinesses(self.businesses)
        })
    }
    
    func searchWithTerm(term: String, limit: Int?, offset: Int?, filters: [String: AnyObject]) -> Void {
        print(filters)
        let deals = filters[Utils.DealsFilter] as? Bool
        let distance = filters[Utils.DistanceFilter] as? Int
        let sortBy = filters[Utils.SortByFilter] as? Int
        let categories = filters[Utils.CategoriesFilter] as? [String]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm(lastSearchTerm, limit: limit, offset: offset, sort: YelpSortMode(rawValue: sortBy!), categories: categories, deals: deals, distance: distance) { (businesses: [Business]!, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.businesses = businesses
            self.tableView.reloadData()
            self.addAnnotationForBusinesses(self.businesses)
        }
    }
    
    @IBAction func didViewModeChanged(sender: UIBarButtonItem) {
        if currentViewMode == .List {
            currentViewMode = .Map
            UIView.transitionWithView(
                view,
                duration: 0.5,
                options: [.TransitionFlipFromRight],
                animations: {
                    self.tableView.hidden = true
                    self.mapView.hidden = false
                },
                completion: nil
            )
        } else {
            currentViewMode = .List
            UIView.transitionWithView(
                view,
                duration: 0.5,
                options: [.TransitionFlipFromLeft],
                animations: {
                    self.tableView.hidden = false
                    self.mapView.hidden = true
                },
                completion: nil
            )
        }
        sender.title = currentViewMode.rawValue
    }
    
    func loadMoreData() {
        searchCurrentOffset += searchDefaultLimit
        if lastSearchFilters == nil {
            print("filters nil")
            Business.searchWithTerm(
                lastSearchTerm,
                limit: searchDefaultLimit,
                offset: searchCurrentOffset,
                completion: { (businesses: [Business]!, error: NSError!) -> Void in
                    self.isMoreDataLoading = false
                    self.loadingMoreView?.stopAnimating()
                    self.businesses.appendContentsOf(businesses)
                    self.tableView.reloadData()
                    self.addAnnotationForBusinesses(self.businesses)
            })
        } else {
            print("filters not nil")
            let deals = lastSearchFilters![Utils.DealsFilter] as? Bool
            let distance = lastSearchFilters![Utils.DistanceFilter] as? Int
            let sortBy = lastSearchFilters![Utils.SortByFilter] as? Int
            let categories = lastSearchFilters![Utils.CategoriesFilter] as? [String]
            // add hub progress
            Business.searchWithTerm(lastSearchTerm,
                                    limit: searchDefaultLimit,
                                    offset: searchCurrentOffset,
                                    sort: YelpSortMode(rawValue: sortBy!),
                                    categories: categories,
                                    deals: deals,
                                    distance: distance) { (businesses: [Business]!, error: NSError!) -> Void in
                                        self.isMoreDataLoading = false
                                        self.loadingMoreView?.stopAnimating()
                                        self.businesses.appendContentsOf(businesses)
                                        self.tableView.reloadData()
                                        self.addAnnotationForBusinesses(self.businesses)
            }
        }
    }
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
        cell.addressLabel.text = nil
        cell.categoriesLabel.text = nil
        cell.thumbImageView.image = nil
        cell.ratingImageView.image = nil
        
        cell.row = indexPath.row
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
}

// MARK: - FiltersViewControllerDelegate

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        lastSearchFilters = filters
        searchWithTerm(lastSearchTerm, limit: searchDefaultLimit, offset: searchDefaultOffset, filters: filters)
    }
}

// MARK: - UISearchBarDelegate

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = lastSearchTerm
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        let searchTerm = searchBar.text!
        lastSearchTerm = searchTerm
        NSUserDefaults.standardUserDefaults().setObject(lastSearchTerm, forKey: Utils.LastSearchTerm)
        lastSearchFilters = nil
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: Utils.IsFiltered)
        searchCurrentOffset = searchDefaultOffset
        searchWithTerm(lastSearchTerm, limit: searchDefaultLimit, offset: searchDefaultOffset)
        searchBar.resignFirstResponder()
    }
}

//MARK: - MKMapView

extension BusinessesViewController {
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    private func addAnnotationForBusinesses(businesses: [Business]) {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        
        for business in businesses {
            let coordinate = CLLocationCoordinate2D(latitude: business.coordinate.latitude!, longitude: business.coordinate.longitude!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = business.name
            mapView.addAnnotation(annotation)
        }
        
        zoomMapToFitAnnotationsForBusiness(businesses)
    }
    
    private func zoomMapToFitAnnotationsForBusiness(businesses: [Business]) {
        let rectToDisplay = self.businesses.reduce(MKMapRectNull) { (mapRect: MKMapRect, business: Business) -> MKMapRect in
            let coordinate = CLLocationCoordinate2D(latitude: business.coordinate.latitude!, longitude: business.coordinate.longitude!)
            let businessPointRect = MKMapRect(origin: MKMapPointForCoordinate(coordinate), size: MKMapSize(width: 0, height: 0))
            return MKMapRectUnion(mapRect, businessPointRect)
        }
        self.mapView.setVisibleMapRect(rectToDisplay, edgePadding: UIEdgeInsetsMake(74, 20, 20, 20), animated: false)
    }
}
