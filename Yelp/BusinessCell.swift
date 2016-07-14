//
//  BusinessCell.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/13/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var row: Int!
    var business: Business! {
        didSet {
            nameLabel.text = "\(row + 1). " + business.name!
            distanceLabel.text = business.distance
            if let reviewsCount = business.reviewCount {
                reviewsCountLabel.text = "\(reviewsCount) Review" + (reviewsCount == 1 ? "" : "s")
            }
            priceLabel.text = "$$$$"
            if let address = business.address {
                addressLabel.text = address
            }
            categoriesLabel.text = business.categories
            if let imageURL = business.imageURL {
                thumbImageView.setImageWithURL(imageURL)
            }
            if let ratingImageURL = business.ratingImageURL {
                ratingImageView.setImageWithURL(ratingImageURL)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
