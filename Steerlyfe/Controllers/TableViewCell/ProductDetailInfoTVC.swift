//
//  ProductDetailInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 13/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class ProductDetailInfoTVC: UITableViewCell {

    var delegate : ButtonPressedAtPositionDelegate?
    
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        CommonMethods.addBackgroundShadowStyle(uiView: mainView, cornerRadius: 20.0, shadowRadius: 20.0)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
        CommonMethods.setRatingStarStyle(ratingView: ratingView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : ProductDetail?, delegate : ButtonPressedAtPositionDelegate, databaseMethods : DatabaseMethods) {
        self.delegate = delegate
        productNameLabel.text = data?.product_name
        ratingView.rating = data?.rating ?? 0.0
        ratingView.text = "(\(data?.rating_count ?? 0) Reviews)"
        productImage.sd_setImage(with: URL(string: data?.image_url ?? "" ), placeholderImage: UIImage(named: MyConstants.PLACEHOLDER_IMAGE_NAME), options: .highPriority) { (image, error, cacheType, url) in
        }
        if databaseMethods.isProductFavourite(productId: data?.product_id ?? "") ?? false{
            favouriteIcon.image = UIImage(named: "heart_icon_filled")
        }else{
            favouriteIcon.image = UIImage(named: "heart_icon")
        }
    }
    
    @IBAction func favouriteIconPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.ADD_TO_FAVOURITES, position: 0)
    }
    
}
