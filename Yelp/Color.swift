//
//  Color.swift
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
    UINavigationBar.appearance().barTintColor = Color.yelpMainColor()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UISearchBar.appearance().translucent = false
    UISearchBar.appearance().barTintColor = Color.yelpMainColor()
}

class Color {
    class func yelpMainColor() -> UIColor {
        return UIColor(red:240.0/255.0, green:71.0/255.0, blue:49.0/255.0, alpha:1.0)
    }

    class func yelpBgrColor() -> UIColor {
        return UIColor(red:239.0/255.0, green:239.0/255.0, blue:244.0/255.0, alpha:1.0)
    }
    
    class func yelpFloatLightBackground() -> UIColor {
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }
    
    class func yelpFloatBorder() -> UIColor {
        return UIColor(red:0.79, green:0.80, blue:0.78, alpha:1.0)
    }
}