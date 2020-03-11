//
//  OrderStatusIndicatorTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 07/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderStatusIndicatorTVC: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var checkedIcon: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(currentData : OrderProductLogDetail?, nextData : OrderProductLogDetail?, currentIndex : Int, lastCheckedIndex : Int) {
        statusLabel.text = CommonMethods.getStatusDisplayText(status: currentData?.type)
        if currentData?.value ?? false{
            checkedIcon.image = UIImage(named: "radio_checked")
        }else{
            checkedIcon.image = UIImage(named: "radio_unchecked")
        }
        if let nextDataValue = nextData{
            if nextDataValue.value ?? false{
                bottomView.backgroundColor = UIColor.statusIndicatorLight
            }else{
                bottomView.backgroundColor = UIColor.statusIndicatorUnchecked
            }
            bottomView.isHidden = false
        }else{
            bottomView.backgroundColor = UIColor.statusIndicatorUnchecked
            bottomView.isHidden = true
        }
        if currentIndex == lastCheckedIndex{
            dateLabel.text = CommonMethods.getSpecialFormattedDate(format: "MMMM dd, yyyy", timeStamp: currentData?.time ?? NSDate().timeIntervalSince1970)
        }else{
            dateLabel.text = ""
        }
    }
}
