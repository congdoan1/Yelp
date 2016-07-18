//
//  Theme.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/18/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import Foundation
import UIKit

public func applyTheme() {
    UINavigationBar.appearance().translucent = false
    UINavigationBar.appearance().barStyle = .Black
    UINavigationBar.appearance().barTintColor = UIColor.yelpRed()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UISearchBar.appearance().translucent = false
    UISearchBar.appearance().barTintColor = UIColor.yelpRed()
}

extension UIColor {
    class func yelpRed() -> UIColor {
        return UIColor(red:0.76, green:0.02, blue:0.04, alpha:1.0)
    }
    
    class func yelpFloatLightBackground() -> UIColor {
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }
    
    class func yelpFloatBorder() -> UIColor {
        return UIColor(red:0.79, green:0.80, blue:0.78, alpha:1.0)
    }
}