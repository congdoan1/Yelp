//
//  BusinessDetailsView.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/15/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

class BusinessDetailsHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet var dividerViews: [UIView]!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var writeReviewContainerView: UIView!
    
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
        }
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
        
        writeReviewContainerView.layer.cornerRadius = 7
        writeReviewContainerView.layer.borderWidth = 1
        writeReviewContainerView.layer.borderColor = UIColor.yelpFloatBorder().CGColor
        writeReviewContainerView.backgroundColor = UIColor.yelpFloatLightBackground()
        
        bottomContainerView.backgroundColor = UIColor.yelpFloatLightBackground()
        for dividerView in dividerViews {
            dividerView.backgroundColor = UIColor.yelpFloatBorder()
        }
    }
}
