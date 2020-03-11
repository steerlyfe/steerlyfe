//
//  TrendingProductsCVC.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class TrendingProductsCVC: UICollectionViewCell {

    let TAG = "TrendingProductsCVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 0.0)
    }

    func setDetail(productDetail : ProductDetail?, delegate : ButtonPressedAtPositionDelegate, position : Int, databaseMethods : DatabaseMethods) {
        self.delegate = delegate
        self.position = position
        productName.text = productDetail?.product_name
        productPrice.text = "\(MyConstants.CURRENCY_SYMBOL)\(productDetail?.sale_price ?? 0.0)"
        productImage.sd_setImage(with: URL(string: productDetail?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
        if databaseMethods.isProductFavourite(productId: productDetail?.product_id ?? "") ?? false{
            favouriteIcon.image = UIImage(named: "favourite_filled")
        }else{
            favouriteIcon.image = UIImage(named: "favourite_colored")
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.ADD_TO_FAVOURITES, position: position)
    }
    
    @IBAction func viewProductDetail(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.TRENDING_VIEW_DETAIL, position: position)
    }
    
}
