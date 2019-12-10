//
//  NearbyStoresCVC.swift
//  Steerlyfe
//
//  Created by nap on 04/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class NearbyStoresCVC: UICollectionViewCell {
    
    let TAG = "NearbyStoresCVC"
    
    var buttonDelegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var moreDetailButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.common.setRatingStarStyle(ratingView: ratingView)
        addressLabel.textColor = UIColor.myGreyColor
        CommonMethods.common.roundCornerView(uiView: mainView, cornerRadius: 10.0)
        CommonMethods.common.makeRoundImageView(imageView: profilePic, cornerRadius: 25.0)
        moreDetailButton.buttonStrokeColorPrimaryDark()
    }
    
    func setDetail(data : StoreDetail?, buttonDelegate : ButtonPressedAtPositionDelegate?, position : Int) {
        self.buttonDelegate = buttonDelegate
        self.position = position
        profilePic.sd_setImage(with: URL(string: data?.storeLogo ?? "" )) { (image, error, cacheType, url) in
        }
        nameLabel.text = data?.storeName
        addressLabel.text = data?.address
        ratingView.rating = data?.storeRating ?? 0.0
        mainView.layer.borderWidth = 1
        if data?.selected ?? false{
            mainView.layer.borderColor = UIColor.colorPrimaryDark.cgColor
        }else{
            mainView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func moreDetailButtonPressed(_ sender: Any) {
        CommonMethods.common.showLog(tag: TAG, message: "moreDetailButtonPressed")
        buttonDelegate?.onButtonPressed(type: "MoreDetail", position: position)
    }
    
}
