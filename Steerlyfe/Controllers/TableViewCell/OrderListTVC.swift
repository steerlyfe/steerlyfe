//
//  OrderListTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderListTVC: UITableViewCell {

    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var mainRatingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceInfoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var infoOuterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoOuterView.backgroundColor = UIColor.colorPrimaryDarkTrans
        CommonMethods.addRoundCornerFilled(uiview: ratingView, borderWidth: 0.0, borderColor: UIColor.orange, backgroundColor: UIColor.orange, cornerRadius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : OrderDetail, delegate : ButtonPressedAtPositionDelegate?, position : Int) {
        self.delegate = delegate
        self.position = position
        orderNumberLabel.text = "Order # \(data.order_id ?? "")"
        dateLabel.text = "Placed \(CommonMethods.getSpecialFormattedDate(format: "dd.MM.yyyy", timeStamp: data.order_time ?? NSDate().timeIntervalSince1970))"
        var itemText = "Items"
        if data.order_info.count == 1{
            itemText = "Item"
        }
        priceInfoLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(CommonMethods.roundOffDouble(value: data.total_amount ?? 0.00, roundOffDigits: 2)). \(data.order_info.count) \(itemText)"
        if data.order_status == MyConstants.ORDER_STATUS_PENDING{
            statusLabel.text = "Pending"
            statusLabel.textColor = UIColor.orange
            mainRatingView.isHidden = true
        }else if data.order_status == MyConstants.ORDER_STATUS_COMPLETED{
            statusLabel.text = "Completed"
            statusLabel.textColor = UIColor.green
            if let rating = data.order_rating{
                if rating > 0.0{
                    mainRatingView.isHidden = false
                    ratingLabel.text = "\(CommonMethods.roundOffDouble(value: rating, roundOffDigits: 1))"
                }else{
                    mainRatingView.isHidden = true
                }
            }else{
                mainRatingView.isHidden = true
            }
        }else if data.order_status == MyConstants.ORDER_STATUS_CANCELLED{
            statusLabel.text = "Cancelled"
            statusLabel.textColor = UIColor.red
            mainRatingView.isHidden = true
        }else{
            statusLabel.textColor = UIColor.black
            statusLabel.text = ""
            mainRatingView.isHidden = true
        }
    }
    
    @IBAction func viewDetailPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.VIEW_ORDER_DETAIL, position: position)
    }
}
