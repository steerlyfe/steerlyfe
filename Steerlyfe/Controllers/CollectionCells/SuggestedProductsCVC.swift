//
//  SuggestedProductsCVC.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class SuggestedProductsCVC: UICollectionViewCell {

    let TAG = "SuggestedProductsCVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
//        self.backgroundColor = UIColor.red
    }
    
    func setDetail(productDetail : ProductDetail?, delegate : ButtonPressedAtPositionDelegate, position : Int, cellWidth : CGFloat, cellHeight : CGFloat) {
        mainViewWidth.constant = cellWidth - 10.0
        mainViewHeight.constant = cellHeight - 10.0
        mainView.backgroundColor = UIColor.white
        var color = UIColor.colorPrimaryDark
        color = color.withAlphaComponent(0.8)
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 40.0, shadowColor: color)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
        self.delegate = delegate
        self.position = position
        productImage.sd_setImage(with: URL(string: productDetail?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
    }
    
    @IBAction func viewDetailButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.TRENDING_VIEW_DETAIL, position: position)
    }
}
