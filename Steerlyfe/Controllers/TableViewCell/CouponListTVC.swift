//
//  CouponListTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 30/03/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class CouponListTVC: UITableViewCell {

    var delegate : ButtonPressedAtPositionDelegate?, position : Int = 0
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var applyCoupon: UIButton!
    @IBOutlet weak var couponInfoLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.gray)
        CommonMethods.addRoundCornerFilled(uiview: applyCoupon, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : CouponDetail?, delegate : ButtonPressedAtPositionDelegate?, position : Int) {
        self.delegate = delegate
        self.position = position
        if data?.discountType == MyConstants.DISCOUNT_TYPE_AMOUNT{
            couponInfoLabel.text = "Get \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.discountAmount ?? 0.0, roundOffDigits: 2)) discount for minimum purchase of \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.moreThenAmount ?? 0.0, roundOffDigits: 2))"
        }else{
            couponInfoLabel.text = "Get \(data?.discountPercentage ?? 0.0)% discount upto \(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.discountPercentageUptoAmount ?? 0.0, roundOffDigits: 2))"

        }
        couponNameLabel.textColor = UIColor.colorSecondary
        couponNameLabel.text = data?.couponCode?.uppercased()
//        CommonMethods.setGradient(uiLabel: couponNameLabel, startColor: UIColor.colorPrimary, endColor: UIColor.colorPrimaryDark)
    }
    
    @IBAction func applyCouponPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.APPLY_COUPON, position: position)
    }
}
