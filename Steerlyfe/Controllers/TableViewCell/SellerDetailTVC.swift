//
//  SellerDetailTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 18/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class SellerDetailTVC: UITableViewCell {
    
    let TAG = "SellerDetailTVC"
    
    var sellerDetail : SellerDetail?
    var productAvailability : ProductAvailability?
    var databaseMethods : DatabaseMethods?
    var additionalFeatureText : String?
    var productDetail : ProductDetail?
    var delegate : OnProcessCompleteDelegate?
    var additionalFeatureIndex : Int = 0
    
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var extraCostLabel: UILabel!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var notAvailableLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var storeInfoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addRoundCornerFilled(uiview: ratingView, borderWidth: 0.0, borderColor: UIColor.orange, backgroundColor: UIColor.orange, cornerRadius: 5.0)
        CommonMethods.addRoundCornerFilled(uiview: addToCartButton, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: addToCartButton.frame.height / 2.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(productDetail : ProductDetail?, additionalFeatureIndex : Int, productAvailabilityIndex : Int, sellerDetailIndex : Int, databaseMethods : DatabaseMethods?, delegate : OnProcessCompleteDelegate?) {
        CommonMethods.showLog(tag: TAG, message: "productAvailabilityIndex : \(productAvailabilityIndex)")
        self.databaseMethods = databaseMethods
        self.productDetail = productDetail
        self.additionalFeatureIndex = additionalFeatureIndex
        self.delegate = delegate
        let additionalFeature = productDetail?.additional_features[additionalFeatureIndex]
        additionalFeatureText = "\(additionalFeature?.value ?? "") \(additionalFeature?.unitType ?? "")"
        sellerDetail = additionalFeature?.sellers[sellerDetailIndex]
        productAvailability = productDetail?.product_availability[productAvailabilityIndex]
        if productAvailability?.available ?? false{
            notAvailableLabel.isHidden = true
            informationStackView.isHidden = false
            let price = ( productDetail?.sale_price ?? 0.0 ) + ( additionalFeature?.price ?? 0.0)
            priceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: price, roundOffDigits: 2))"
            if let extraPrice = productAvailability?.price{
                if extraPrice > 0{
                    if let type = productAvailability?.type{
                        extraCostLabel.isHidden = false
                        if type == MyConstants.PRODUCT_AVAILABLITY_IN_STORE{
                            extraCostLabel.text = "In-Store Charges \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: extraPrice, roundOffDigits: 2))"
                        }else if type == MyConstants.PRODUCT_AVAILABLITY_DELIVER_NOW{
                            extraCostLabel.text = "Delivery Charges \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: extraPrice, roundOffDigits: 2))"
                        }else if type == MyConstants.PRODUCT_AVAILABLITY_SHIPPING{
                            extraCostLabel.text = "Groundshipping \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: extraPrice, roundOffDigits: 2))"
                        }
                    }else{
                        extraCostLabel.isHidden = true
                    }
                }else{
                    extraCostLabel.isHidden = true
                }
            }else{
                extraCostLabel.isHidden = true
            }
            if let storeName = sellerDetail?.name{
                if let address = sellerDetail?.address{
                    storeInfoLabel.text = "\(storeName) - \(address)"
                }else{
                    storeInfoLabel.text = storeName
                }
            }else{
                if let address = sellerDetail?.address{
                    storeInfoLabel.text = address
                }else{
                    storeInfoLabel.text = ""
                }
            }
            setQuantity()
            ratingLabel.text = "\(CommonMethods.roundOffDouble(value: sellerDetail?.rating ?? 0.0, roundOffDigits: 2))"
        }else{
            notAvailableLabel.isHidden = false
            informationStackView.isHidden = true
            var message = "It seems like \(productDetail?.product_name ?? "this product") is not available"
            if let type = productAvailability?.type{
                if type == MyConstants.PRODUCT_AVAILABLITY_IN_STORE{
                    message = "\(message) in store."
                }else if type == MyConstants.PRODUCT_AVAILABLITY_DELIVER_NOW{
                    message = "\(message) for delivery."
                }else if type == MyConstants.PRODUCT_AVAILABLITY_SHIPPING{
                    message = "\(message) for shipping."
                }
            }
            notAvailableLabel.text = message
        }
    }
    
    
    func getQuantity() -> Int {
        let quantity = databaseMethods?.getCartProductQuantity(productId: productDetail?.product_id, additional_feature: additionalFeatureText, sub_store_id: sellerDetail?.sub_store_id, available_type: productAvailability?.type) ?? 0
        return quantity
    }
    
    func getCartProductId() -> Int {
        let cartProductId = databaseMethods?.getCartProductId(productId: productDetail?.product_id, additional_feature: additionalFeatureText, sub_store_id: sellerDetail?.sub_store_id, available_type: productAvailability?.type) ?? 0
        return cartProductId
    }
    
    func setQuantity() {
        let quantity = getQuantity()
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
    
    @IBAction func addToCartPressed(_ sender: Any) {
        let additionalFeature = productDetail?.additional_features[additionalFeatureIndex]
        let cartProduct = CartProductDetail(cart_product_id: 0, product_id: productDetail?.product_id ?? "", product_name: productDetail?.product_name ?? "", store_id: sellerDetail?.store_id ?? "", store_name: sellerDetail?.name, description: productDetail?.description ?? "", actual_price: productDetail?.actual_price ?? 0.0, sale_price: productDetail?.sale_price ?? 0.0, image_url: productDetail?.image_url ?? "", quantity: 1, additional_feature: additionalFeatureText ?? "", available_type: productAvailability?.type ?? "", sub_store_id: sellerDetail?.sub_store_id ?? "", additional_charges: productAvailability?.price ?? 0.0, additional_feature_price: additionalFeature?.price, sub_store_address: sellerDetail?.address)
        if databaseMethods?.addProductInCart(productDetail: cartProduct) ?? false{
            setQuantity()
            delegate?.onProcessComplete(type: MyConstants.ADD_TO_CART, status: "1", message: "")
            delegate?.onProcessComplete(type: MyConstants.REFRESH_PRODUCT_LIST_DATA, status: "1", message: "")
        }else{
            MyNavigations.showCommonMessageDialog(message: "Item not added to cart, Please try again", buttonTitle: "Ok")
        }
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        let quantity = getQuantity()
        CommonMethods.showLog(tag: TAG, message: "plusPressed quantity : \(quantity)")
        if quantity > 0{
            if databaseMethods?.updateProductQuantity(productCartId: getCartProductId(), quantity: quantity + 1) ?? false{
                CommonMethods.showLog(tag: TAG, message: "Product Quantity Plus")
                setQuantity()
                delegate?.onProcessComplete(type: MyConstants.REFRESH_PRODUCT_LIST_DATA, status: "1", message: "")
            }
        }else{
            addToCartPressed(sender)
        }
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        let quantity = getQuantity()
        CommonMethods.showLog(tag: TAG, message: "minusPressed quantity : \(quantity)")
        if quantity > 1{
            if databaseMethods?.updateProductQuantity(productCartId: getCartProductId(), quantity: quantity - 1) ?? false{
                CommonMethods.showLog(tag: TAG, message: "Product Quantity Plus")
                setQuantity()
                delegate?.onProcessComplete(type: MyConstants.REFRESH_PRODUCT_LIST_DATA, status: "1", message: "")
            }
        }else{
            if databaseMethods?.deleteCartProduct(cartProductId: getCartProductId()) ?? false{
                setQuantity()
                delegate?.onProcessComplete(type: MyConstants.REFRESH_PRODUCT_LIST_DATA, status: "1", message: "")
            }
        }
    }
}
