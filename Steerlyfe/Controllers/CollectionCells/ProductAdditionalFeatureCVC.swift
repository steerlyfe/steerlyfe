//
//  ProductAdditionalFeatureCVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 17/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class ProductAdditionalFeatureCVC: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDetail(data : AdditionalFeatures?, currentPosition : Int?, selectedPosition : Int?) {
        nameLabel.text = "\(data?.value ?? "") \(data?.unitType ?? "")"
        if currentPosition == selectedPosition{
            setColorStyle(backColor: UIColor.black, textColor: UIColor.white)
        }else{
            setColorStyle(backColor: UIColor.myLineLightColor, textColor: UIColor.black)
        }
    }
    
    func setColorStyle(backColor : UIColor, textColor : UIColor) {
        CommonMethods.addRoundCornerFilled(uiview: mainView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: backColor, cornerRadius: 20.0)
        nameLabel.textColor = textColor
    }
}
