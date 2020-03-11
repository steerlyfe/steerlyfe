//
//  CategoryTitleCVC.swift
//  Steerlyfe
//
//  Created by nap on 06/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class CategoryTitleCVC: UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setDetail(data : CategoryDetail?, currentCategory : CategoryDetail?) {
        categoryName.text = data?.categoryName
        if data?.categoryId == currentCategory?.categoryId{
            setColorStyle(backColor: UIColor.black, textColor: UIColor.white)
        }else{
            setColorStyle(backColor: UIColor.myLineLightColor, textColor: UIColor.black)
        }
    }
    
    func setColorStyle(backColor : UIColor, textColor : UIColor) {
        CommonMethods.addRoundCornerFilled(uiview: mainView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: backColor, cornerRadius: 20.0)
        categoryName.textColor = textColor
    }
}
