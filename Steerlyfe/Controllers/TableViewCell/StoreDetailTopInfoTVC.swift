//
//  StoreDetailTopInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 29/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class StoreDetailTopInfoTVC: UITableViewCell {
    
    let TAG = "StoreDetailTopInfoTVC"
    
    var data : StoreDetail?
    var delegate : ButtonPressedDelegate?
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var logoIcon: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var logoBackView: UIView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var messageBackStyleView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        CommonMethods.setRatingStarStyle(ratingView: ratingView)
        CommonMethods.makeRoundImageView(imageView: logoIcon, cornerRadius: 10.0)
        CommonMethods.addCardViewStyle(uiView: logoBackView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        let messageHeight = messageView.frame.height
        CommonMethods.addCardViewStyle(uiView: messageView, cornerRadius: messageHeight / 2.0, shadowRadius: 5.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        CommonMethods.addRoundCornerFilled(uiview: messageBackStyleView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 20.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : StoreDetail?, height : CGFloat, delegate : ButtonPressedDelegate?) {
        self.data = data
        self.delegate = delegate
        CommonMethods.showLog(tag: TAG, message: "height : \(height)")
        topViewHeight.constant = height
        storeName.text = data?.storeName
        ratingView.rating = data?.storeRating ?? 0.0
        logoIcon.sd_setImage(with: URL(string: data?.storeLogo ?? "" )) { (image, error, cacheType, url) in
        }
        bannerImage.sd_setImage(with: URL(string: data?.bannerUrl ?? "" )) { (image, error, cacheType, url) in
        }
        descLabel.text = data?.description
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
    }
}

