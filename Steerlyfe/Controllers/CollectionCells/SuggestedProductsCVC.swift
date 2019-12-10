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
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        CommonMethods.common.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 0.0)
    }
    
    func setDetail(productDetail : ProductDetail?, delegate : ButtonPressedAtPositionDelegate, position : Int) {
        self.delegate = delegate
        self.position = position
        productImage.sd_setImage(with: URL(string: productDetail?.image_url ?? "" )) { (image, error, cacheType, url) in
        }
    }
    
    @IBAction func viewDetailButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: "ViewDetail", position: position)
    }
}
