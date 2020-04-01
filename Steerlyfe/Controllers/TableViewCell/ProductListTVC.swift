//
//  ProductListTVC.swift
//  Steerlyfe
//
//  Created by nap on 01/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class ProductListTVC: UITableViewCell {
    
    let TAG = "ProductListTVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    var databaseMethods : DatabaseMethods?
    var calledFrom : String?
    var productId : String?
    var cartProductId : Int?
    
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        mainView.backgroundColor = UIColor.white
        //        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 10.0)
//        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0,shadowColor: UIColor.colorPrimaryDarkTrans)
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 20.0, shadowColor: UIColor.lightGray)
        //        CommonMethods.addRoundCornerFilled(uiview: mainView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 10.0)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
        CommonMethods.addRoundCornerFilled(uiview: quantityView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: quantityView.frame.height / 2.0)
        CommonMethods.addRoundCornerFilled(uiview: addToCartButton, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.white, cornerRadius: addToCartButton.frame.height / 2.0)
        //        CommonMethods.addRoundCornerStroke(uiview: addToCartButton, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: addToCartButton.frame.height / 2.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : ProductDetail?, delegate : ButtonPressedAtPositionDelegate?, position : Int, databaseMethods : DatabaseMethods, calledFrom : String) {
        self.delegate = delegate
        self.position = position
        self.calledFrom = calledFrom
        self.databaseMethods = databaseMethods
        self.productId = data?.product_id
        self.cartProductId = databaseMethods.getCartProductId(productId: self.productId)
        productName.text = data?.product_name
        productPrice.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.sale_price ?? 0.0, roundOffDigits: 2) )"
        productDesc.text = data?.description
        if let storeName = data?.store_name {
            sellerName.isHidden = false
            sellerName.text = "Seller : \(storeName)"
        }else{
            sellerName.isHidden = true
        }
        productImage.sd_setImage(with: URL(string: data?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
        setQuantity()
        if calledFrom == MyConstants.FAVOURITE_LIST{
            deleteView.isHidden = false
        }else{
            deleteView.isHidden = true
        }
    }
    
//    func setCartDetail(data : CartProductDetail?, delegate : ButtonPressedAtPositionDelegate?, position : Int, databaseMethods : DatabaseMethods) {
//        self.delegate = delegate
//        self.position = position
//        self.databaseMethods = databaseMethods
//        self.productId = data?.product_id
//        self.cartProductId = data?.cart_product_id
//        productName.text = data?.product_name
//        let price = ( data?.sale_price ?? 0.0 ) + (data?.additional_feature_price ?? 0.0)
//        productPrice.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: price, roundOffDigits: 2))"
//        productDesc.text = data?.description
//        if let storeName = data?.store_name {
//            sellerName.isHidden = false
//            sellerName.text = "Seller : \(storeName)"
//        }else{
//            sellerName.isHidden = true
//        }
//        productImage.sd_setImage(with: URL(string: data?.image_url ?? "" )) { (image, error, cacheType, url) in
//        }
//        setCartQuantity()
//        deleteView.isHidden = true
//    }
    
    func setQuantity() {
        let quantity = databaseMethods?.getCartProductQuantity(productId: productId) ?? 0
        if quantity > 0{
            addToCartButton.isHidden = true
            quantityView.isHidden = false
            quantityLabel.text = "\(quantity)"
            CommonMethods.showLog(tag: TAG, message: "quantity : \(quantity)")
        }else{
            addToCartButton.isHidden = false
            quantityView.isHidden = true
        }
    }
    
    func setCartQuantity() {
        let quantity = databaseMethods?.getCartProductQuantity(cartProductId: cartProductId) ?? 0
        if quantity > 0{
            addToCartButton.isHidden = true
            quantityView.isHidden = false
            quantityLabel.text = "\(quantity)"
            CommonMethods.showLog(tag: TAG, message: "quantity : \(quantity)")
        }else{
            addToCartButton.isHidden = false
            quantityView.isHidden = true
        }
        
    }
    
    @IBAction func plusPressed(_ sender: Any) {
//        let quantity = databaseMethods?.getCartProductQuantity(productId: productId) ?? 0
//        CommonMethods.showLog(tag: TAG, message: "plusPressed quantity : \(quantity)")
//        if quantity > 0{
//            let product = databaseMethods?.getCartProductDetail(productId: productId)
//            product?.quantity = (product?.quantity ?? 0) + 1
//            if databaseMethods?.updateProductQuantity(productCartId: product?.cart_product_id ?? 0, quantity: ( (product?.quantity ?? 0) + 1) ) ?? false{
//                CommonMethods.showLog(tag: TAG, message: "Product Quantity Plus")
//            }
//            //            if databaseMethods?.updateProductInCart(productDetail: product) ?? false{
//            //                CommonMethods.showLog(tag: TAG, message: "Product Added to cart")
//            //            }
//        }else{
//            //            if databaseMethods?.addProductInCart(productDetail: data) ?? false{
//            //                CommonMethods.showLog(tag: TAG, message: "Product Added to cart")
//            //                delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
//            //            }
//        }
//        delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
        
        
        
        let quantity = databaseMethods?.getCartProductQuantity(cartProductId: cartProductId) ?? 0
        if quantity > 0{
            if databaseMethods?.updateProductQuantity(productCartId: cartProductId ?? 0, quantity: quantity + 1)  ?? false{
                delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
            }
        }else{
            delegate?.onButtonPressed(type: MyConstants.ADD_TO_CART, position: position)
        }
    }
    
    @IBAction func minusPressed(_ sender: Any) {
//        let quantity = databaseMethods?.getCartProductQuantity(productId: productId) ?? 0
//        if quantity > 1{
//            let product = databaseMethods?.getCartProductDetail(productId: productId)
//            product?.quantity = (product?.quantity ?? 0) - 1
//            if databaseMethods?.updateProductQuantity(productCartId: product?.cart_product_id ?? 0, quantity: ( (product?.quantity ?? 0) + 1) ) ?? false{
//                CommonMethods.showLog(tag: TAG, message: "Product Quantity Minus")
//            }
//        }else{
//            //            databaseMethods?.deleteCartProduct(productId: data?.product_id ?? "")
//            //            delegate?.onButtonPressed(type: MyConstants.REMOVE_ITEM, position: position)
//        }
//        delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
        
        let quantity = databaseMethods?.getCartProductQuantity(cartProductId: cartProductId) ?? 0
        if quantity > 1{
            if databaseMethods?.updateProductQuantity(productCartId: cartProductId ?? 0, quantity: quantity - 1)  ?? false{
                delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
            }
        }else{
            if databaseMethods?.deleteCartProduct(cartProductId: cartProductId ?? 0) ?? false{
//                delegate?.onButtonPressed(type: MyConstants.REMOVE_ITEM, position: position)
            }else{
                MyNavigations.showCommonMessageDialog(message: "Product not removed, Please try again", buttonTitle: "Ok")
            }
        }
        delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.ADD_TO_CART, position: position)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if databaseMethods?.deleteFavouriteProduct(productId: productId ?? "") ?? false{
            delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
            delegate?.onButtonPressed(type: MyConstants.DELETE_FAVOURITE, position: position)
        }
    }
}
