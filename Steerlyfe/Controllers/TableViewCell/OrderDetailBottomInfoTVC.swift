//
//  OrderDetailBottomInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 07/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderDetailBottomInfoTVC: UITableViewCell {

    let TAG = "OrderDetailBottomInfoTVC"
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var buyAgainView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var detailBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailBackView.backgroundColor = UIColor.colorPrimaryDarkTrans
        CommonMethods.addRoundCornerFilled(uiview: buyAgainView, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: buyAgainView.frame.height / 2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : OrderDetail?) {
        let shipping = getShippingAmount(orderInfo: data?.order_info)
        let subTotal = ( data?.total_amount ?? 0.00 ) - shipping
        CommonMethods.showLog(tag: TAG, message: "shipping : \(shipping)")
        CommonMethods.showLog(tag: TAG, message: "subTotal : \(subTotal)")
        CommonMethods.showLog(tag: TAG, message: "total_amount : \(data?.total_amount ?? 0.00)")
        subTotalLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: subTotal, roundOffDigits: 2))"
        shippingLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\( CommonMethods.roundOffDouble(value: shipping, roundOffDigits: 2) )"
        taxLabel.text = "\(MyConstants.CURRENCY_SYMBOL)0.00"
        savingsLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.total_savings ?? 0.00, roundOffDigits: 2))"
        discountLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: ( data?.discount_amount ?? 0.00) + (data?.coupon_discount ?? 0.0), roundOffDigits: 2))"
        totalLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data?.amount_paid ?? 0.00, roundOffDigits: 2))"
    }
    
    @IBAction func buyAllOrdersPressed(_ sender: Any) {
    }
    
    func getShippingAmount(orderInfo : [OrderProductInfo]?) -> Double {
        var price = 0.0
        orderInfo?.forEach({ (info) in
            price = price + (info.product_availability_price ?? 0.0)
        })
        return price
    }
}
