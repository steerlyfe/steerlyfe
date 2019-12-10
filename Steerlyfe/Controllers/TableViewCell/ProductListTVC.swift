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
    
    var data : ProductDetail?
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    var databaseMethods : DatabaseMethods?
    
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
        CommonMethods.common.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 10.0)
        CommonMethods.common.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : ProductDetail?, delegate : ButtonPressedAtPositionDelegate?, position : Int, databaseMethods : DatabaseMethods) {
        self.data = data
        self.delegate = delegate
        self.position = position
        self.databaseMethods = databaseMethods
        productName.text = data?.product_name
        productPrice.text = "\(MyConstants.CURRENCY_SYMBOL)\(data?.sale_price ?? 0.0)"
        productDesc.text = data?.description
        productImage.sd_setImage(with: URL(string: data?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
        setQuantity()
    }
    
    func setQuantity() {
        quantityLabel.text = "\(data?.quantity ?? 0)"
        CommonMethods.common.showLog(tag: TAG, message: "quantity : \(data?.quantity ?? 0)")
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        if databaseMethods?.checkAndUpdateCartProduct(productDetail: data, calledForAdd: true) ?? false{
//            data?.quantity = databaseMethods?.getProductQuantity(productId: data?.product_id ?? "") ?? 0
            setQuantity()
        }
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        if (data?.quantity ?? 0) > 0{
            if databaseMethods?.checkAndUpdateCartProduct(productDetail: data, calledForAdd: false) ?? false{
//                data?.quantity = databaseMethods?.getProductQuantity(productId: data?.product_id ?? "") ?? 0
                setQuantity()
            }
        }
    }
}
