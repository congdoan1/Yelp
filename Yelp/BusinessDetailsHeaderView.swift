//
//  BusinessDetailsHeaderView.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/15/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var contentView: UIView!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            
            if let reviewsCount = business.reviewCount {
                reviewsCountLabel.text = "\(reviewsCount) review" + (reviewsCount == 1 ? "" : "s")
            }
            
            categoriesLabel.text = business.categories
            
            addressLabel.text = business.address
            
            phoneLabel.text = business.phone
            
            distanceLabel.text = business.distance
            
            addAnnotationForBusiness(business)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    func initSubViews() {
        let nib = UINib(nibName: "BusinessDetailsHeaderView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        mapView.userInteractionEnabled = false
    }
    
    private func addAnnotationForBusiness(business: Business) {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        
        let coordinate = CLLocationCoordinate2D(latitude: business.coordinate.latitude!, longitude: business.coordinate.longitude!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = business.name
        mapView.addAnnotation(annotation)
        
        centerAndZoomMapAroundBusiness(business)
    }
    
    private func centerAndZoomMapAroundBusiness(business: Business) {
        if let latitude = business.coordinate.latitude, longitude = business.coordinate.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
}
