//
//  ProductListTVC.swift
//  Steerlyfe
//
//  Created by nap on 01/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class CartProductListTVC: UITableViewCell {
    
    let TAG = "CartProductListTVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    var databaseMethods : DatabaseMethods?
    var calledFrom : String?
    var cartProductId : Int?
    
    @IBOutlet weak var sellerName: UILabel!
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
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.lightGray)
//        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0,shadowColor: UIColor.colorPrimaryDarkTrans)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
        CommonMethods.addRoundCornerFilled(uiview: quantityView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: quantityView.frame.height / 2.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : CartProductDetail?, delegate : ButtonPressedAtPositionDelegate?, position : Int, databaseMethods : DatabaseMethods) {
        self.delegate = delegate
        self.position = position
        self.databaseMethods = databaseMethods
        self.cartProductId = data?.cart_product_id
        productName.text = "\(data?.product_name ?? "") (\(data?.additional_feature ?? ""))"
        let price = ( data?.sale_price ?? 0.0 ) + (data?.additional_feature_price ?? 0.0)
        var priceText = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: price, roundOffDigits: 2))"
        if let type = data?.available_type{
            if type == MyConstants.PRODUCT_AVAILABLITY_DELIVER_NOW{
                priceText = "\(priceText) + \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.additional_charges ?? 0.0, roundOffDigits: 2)) (Delivery Charges)"
            }else if type == MyConstants.PRODUCT_AVAILABLITY_SHIPPING{
                priceText = "\(priceText) + \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.additional_charges ?? 0.0, roundOffDigits: 2)) (Shipping Charges)"
            }
        }
        productPrice.text = priceText
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
    }
        
    func setQuantity() {
        let quantity = databaseMethods?.getCartProductQuantity(cartProductId: cartProductId) ?? 0
        if quantity > 0{
            quantityView.isHidden = false
            quantityLabel.text = "\(quantity)"
            CommonMethods.showLog(tag: TAG, message: "quantity : \(quantity)")
        }else{
            quantityView.isHidden = true
        }
    }
    
    @IBAction func plusPressed(_ sender: Any) {
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
        let quantity = databaseMethods?.getCartProductQuantity(cartProductId: cartProductId) ?? 0
        if quantity > 1{
            if databaseMethods?.updateProductQuantity(productCartId: cartProductId ?? 0, quantity: quantity - 1)  ?? false{
                delegate?.onButtonPressed(type: MyConstants.REFRESH_DATA, position: position)
            }
        }else{
            if databaseMethods?.deleteCartProduct(cartProductId: cartProductId ?? 0) ?? false{
                delegate?.onButtonPressed(type: MyConstants.REMOVE_ITEM, position: position)
            }else{
                MyNavigations.showCommonMessageDialog(message: "Product not removed, Please try again", buttonTitle: "Ok")
            }
        }
    }
    
    @IBAction func viewProductDetail(_ sender: Any) {
         delegate?.onButtonPressed(type: MyConstants.VIEW_DETAIL, position: position)
    }
    
}
