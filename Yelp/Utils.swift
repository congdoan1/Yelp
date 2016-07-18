//
//  Utils.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/18/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import Foundation

class Utils {
    static let sharedInstance = Utils()
    
    static let DealsFilter = "deals"
    static let DistanceFilter = "distance"
    static let SortByFilter = "sortBy"
    static let CategoriesFilter = "categories"
    static let LastSearchTerm = "lastSearchTerm"
    static let IsFiltered = "isFiltered"
    
    func saveLastSearchFilters(filters: [String: AnyObject]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(true, forKey: Utils.IsFiltered)

        userDefaults.setBool((filters[Utils.DealsFilter] as? Bool)!, forKey: Utils.DealsFilter)
        
        userDefaults.setInteger((filters[Utils.DistanceFilter] as? Int)!, forKey: Utils.DistanceFilter)

        userDefaults.setInteger((filters[Utils.SortByFilter] as? Int)!, forKey: Utils.SortByFilter)
        
        if let categories = filters[Utils.CategoriesFilter] as? [String] {
            userDefaults.setObject(categories, forKey: Utils.CategoriesFilter)
        }
    }
    
    func getLastSearchFilters() -> [String: AnyObject] {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var lastFilters = [String: AnyObject]()
        lastFilters[Utils.DealsFilter] = userDefaults.boolForKey(Utils.DealsFilter)
        lastFilters[Utils.DistanceFilter] = userDefaults.integerForKey(Utils.DistanceFilter)
        lastFilters[Utils.SortByFilter] = userDefaults.integerForKey(Utils.SortByFilter)
        lastFilters[Utils.CategoriesFilter] = userDefaults.objectForKey(Utils.CategoriesFilter) as? [String]
        
        return lastFilters
    }
}