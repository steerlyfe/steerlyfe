//
//  ProductInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 13/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class ProductInfoTVC: UITableViewCell {

    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstLabel.textColor = UIColor.gray
        secondLabel.textColor = UIColor.black
        CommonMethods.addRoundCornerFilled(uiview: firstView, borderWidth: 1.0, borderColor: UIColor.gray, backgroundColor: UIColor.myLineColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerFilled(uiview: secondView, borderWidth: 1.0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0.0)
//        CommonMethods.addRoundCornerStroke(uiview: firstView, borderWidth: 1.0, borderColor: UIColor.gray, cornerRadius: 0.0)
//        CommonMethods.addRoundCornerStroke(uiview: secondView, borderWidth: 1.0, borderColor: UIColor.gray, cornerRadius: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : ProductInfo?) {
        firstLabel.text = data?.type
        secondLabel.text = data?.value
    }
}
