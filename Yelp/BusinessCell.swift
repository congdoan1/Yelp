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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var footerSpaceView: UIView!
    
    var row: Int!
    var business: Business! {
        didSet {
            nameLabel.text = "\(row + 1). " + business.name!
            nameLabel.textColor = Color.yelpMainColor()
            
            distanceLabel.text = business.distance
            
            if let reviewsCount = business.reviewCount {
                reviewsCountLabel.text = "\(reviewsCount) review" + (reviewsCount == 1 ? "" : "s")
            }
            
            if let address = business.address {
                addressLabel.text = address
            }
            
            categoriesLabel.text = business.categories
            
            if let imageURL = business.imageURL {
                thumbImageView.setImageWithURL(imageURL)
            }
            if let imageURL = business.imageURL {
                let imageRequest = NSURLRequest(URL: imageURL)
                
                self.thumbImageView.setImageWithURLRequest(
                    imageRequest,
                    placeholderImage: UIImage(named: "yelp"),
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            print("Image was NOT cached, fade in image")
                            self.thumbImageView.alpha = 0.0
                            self.thumbImageView.image = image
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.thumbImageView.alpha = 1.0
                            })
                            
                        } else {
                            print("Image was cached so just update the image")
                            self.thumbImageView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, image) -> Void in
                        // do something for the failure condition
                })
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
        
        footerSpaceView.backgroundColor = Color.yelpBgrColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
