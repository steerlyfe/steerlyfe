//
//  CategoryCVC.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class CategoryCVC: UICollectionViewCell {

    let TAG = "CategoryCVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        categoryName.textColor = UIColor.white
        CommonMethods.common.makeRoundImageView(imageView: categoryImage, cornerRadius: 10.0)
        CommonMethods.common.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 0.0)
    }

    func setDetail(data : CategoryDetail?, delegate : ButtonPressedAtPositionDelegate, position : Int) {
        self.delegate = delegate
        self.position = position
        categoryName.text = data?.categoryName
        categoryImage.sd_setImage(with: URL(string: data?.categoryUrl ?? "" )) { (image, error, cacheType, url) in
        }
    }
    
    @IBAction func viewDetailPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: "ViewDetail", position: position)
    }
}
