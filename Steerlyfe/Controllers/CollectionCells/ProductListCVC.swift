//
//  ProductListCVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 08/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class ProductListCVC: UICollectionViewCell {
    
    let TAG = "TrendingProductsCVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    var databaseMethods : DatabaseMethods?
    var productDetail : ProductDetail?
    
    @IBOutlet weak var quantityInnerView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var mainWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        //        self.backgroundColor = UIColor.colorPrimaryDark
        //        mainView.backgroundColor = UIColor.white
        mainView.backgroundColor = UIColor.white
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.lightGray)
//        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        //
        //        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 0.0)
        CommonMethods.addRoundCornerStroke(uiview: addToCartButton, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: addToCartButton.frame.height / 2.0)
        CommonMethods.addRoundCornerFilled(uiview: quantityInnerView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: quantityInnerView.frame.height / 2.0)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
    }
    
    func setDetail(productDetail : ProductDetail?, delegate : ButtonPressedAtPositionDelegate, position : Int, databaseMethods : DatabaseMethods, width : CGFloat, height : CGFloat) {
        mainWidthConstraint.constant = width - 10.0
        mainHeightConstraint.constant = height - 10.0
        //        CommonMethods.showLog(tag: TAG, message: "mainWidthConstraint : \(mainWidthConstraint.constant)")
        //        CommonMethods.showLog(tag: TAG, message: "mainHeightConstraint : \(mainHeightConstraint.constant)")
        self.delegate = delegate
        self.position = position
        self.databaseMethods = databaseMethods
        self.productDetail = productDetail
        productNameLabel.text = productDetail?.product_name
        priceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(productDetail?.sale_price ?? 0.0)"
        productImage.sd_setImage(with: URL(string: productDetail?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
        if databaseMethods.isProductFavourite(productId: productDetail?.product_id ?? "") ?? false{
            favouriteImage.image = UIImage(named: "favourite_filled")
        }else{
            favouriteImage.image = UIImage(named: "favourite_colored")
        }
        let quantity = databaseMethods.getCartProductQuantity(productId: productDetail?.product_id) ?? 0
        productDetail?.quantity = quantity
        if quantity > 0{
            quantityView.isHidden = false
            addToCartButton.isHidden = true
            quantityLabel.text = "\(quantity)"
        }else{
            quantityView.isHidden = true
            addToCartButton.isHidden = false
        }
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "addToCartPressed")
        delegate?.onButtonPressed(type: MyConstants.ADD_TO_CART, position: position)
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "favouriteButtonPressed")
        delegate?.onButtonPressed(type: MyConstants.ADD_TO_FAVOURITES, position: position)
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        let quantity = databaseMethods?.getCartProductQuantity(productId: productDetail?.product_id) ?? 0
        if quantity > 0{
            let cartProductId = databaseMethods?.getCartProductId(productId: productDetail?.product_id) ?? 0
            if databaseMethods?.updateProductQuantity(productCartId: cartProductId, quantity: quantity + 1)  ?? false{
                delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
            }
        }else{
            delegate?.onButtonPressed(type: MyConstants.ADD_TO_CART, position: position)
        }
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "minusPressed")
        let quantity = databaseMethods?.getCartProductQuantity(productId: productDetail?.product_id) ?? 0
        let cartProductId = databaseMethods?.getCartProductId(productId: productDetail?.product_id) ?? 0
        CommonMethods.showLog(tag: TAG, message: "minusPressed quantity : \(quantity)")
        CommonMethods.showLog(tag: TAG, message: "minusPressed cartProductId : \(cartProductId)")
        if quantity > 1{
            let innerQuantity = databaseMethods?.getCartProductQuantity(cartProductId: cartProductId) ?? 0
            if innerQuantity > 1{
                if databaseMethods?.updateProductQuantity(productCartId: cartProductId, quantity: innerQuantity - 1)  ?? false{
                    delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
                }
            }else{
                if databaseMethods?.deleteCartProduct(cartProductId: cartProductId) ?? false{
                    delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
                }
            }
        }else{
            if databaseMethods?.deleteCartProduct(cartProductId: cartProductId) ?? false{
                delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
            }
        }
    }
    
    @IBAction func viewProductDetail(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.VIEW_DETAIL, position: position)
    }
    
}
