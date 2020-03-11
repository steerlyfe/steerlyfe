//
//  OrderDetailTopInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 07/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderDetailTopInfoTVC: UITableViewCell {

    @IBOutlet weak var shippingOuterView: UIStackView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var cardDetail: UILabel!
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addressView.backgroundColor = UIColor.colorPrimaryDarkTrans
        cardDetailView.backgroundColor = UIColor.colorPrimaryDarkTrans
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(addressDetail : AddressDetail?, productCount : Int) {
        if let address = addressDetail{
            shippingOuterView.isHidden = false
            addressLabel.text = CommonMethods.getAddressText(addressDetail: address)
        }else{
            shippingOuterView.isHidden = true
        }
        itemCountLabel.text = "Items (\(productCount))".uppercased()
    }
}
