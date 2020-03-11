//
//  OldProductsCVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 07/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class OldProductsCVC: UICollectionViewCell {

    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var mainWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
//        mainView.backgroundColor = UIColor.white
        CommonMethods.addRoundCornerFilled(uiview: mainView, borderWidth: 1.0, borderColor: UIColor.myLineLightColor, backgroundColor: UIColor.white, cornerRadius: 10.0)
//        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.lightGray)
//        CommonMethods.addRoundCornerFilled(uiview: mainView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 10.0)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
    }

    func setDetail(width : CGFloat, height : CGFloat, productDetail : ProductDetail?, delegate : ButtonPressedAtPositionDelegate?, position : Int) {
        self.delegate = delegate
        self.position = position
        mainWidth.constant = width
        mainHeight.constant = height
        productName.text = productDetail?.product_name
        priceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: productDetail?.sale_price ?? 0.0, roundOffDigits: 2) )"
        productImage.sd_setImage(with: URL(string: productDetail?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.ADD_TO_CART, position: position)
    }
    
    @IBAction func productImageButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.VIEW_PRODUCT_DETAIL, position: position)
    }
}
