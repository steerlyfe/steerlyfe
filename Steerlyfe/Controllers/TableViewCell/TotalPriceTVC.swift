//
//  TotalPriceTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 09/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class TotalPriceTVC: UITableViewCell {
    
    @IBOutlet weak var couponDiscountLabel: UILabel!
    @IBOutlet weak var orderCostLabel: UILabel!
    @IBOutlet weak var couponView: UIStackView!
    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(cartProducts : [CartProductDetail], couponApplied : Bool, appliedCouponDetail : ApplyCouponResponse?) {
        let totalCost = CommonMethods.getTotalPrice(data: cartProducts)
        if couponApplied{
            couponView.isHidden = false
            couponName.text = appliedCouponDetail?.couponCode?.uppercased()
            orderCostLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(totalCost)"
            couponDiscountLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: appliedCouponDetail?.discountAmount ?? 0.0, roundOffDigits: 2))"
            totalPriceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: appliedCouponDetail?.payableAmountAfterDiscount ?? 0.0, roundOffDigits: 2))"
        }else{
            couponView.isHidden = true
            totalPriceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(totalCost)"
        }
    }
}
