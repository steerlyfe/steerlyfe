//
//  DiscoverTVC.swift
//  Steerlyfe
//
//  Created by nap on 01/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class DiscoverTVC: UITableViewCell {

    let TAG = "DiscoverTVC"
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var labelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelViewWidth: NSLayoutConstraint!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.textColor = UIColor.white
        var color = UIColor.black.cgColor
        color = color.copy(alpha: 0.5) ?? UIColor.black.cgColor
        labelView.layer.backgroundColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : CategoryDetail) {
        categoryName.text = data.categoryName
    }
    
    func setDetail(data : CategoryDetail?, delegate : ButtonPressedAtPositionDelegate, position : Int) {
        self.delegate = delegate
        self.position = position
//        data?.categoryName = "Hii helloi Kiddaaaaa"
        labelViewWidth.constant = 125.0
        if let value = data?.categoryName{
            CommonMethods.showLog(tag: TAG, message: "value : \(value)")
            CommonMethods.showLog(tag: TAG, message: "BEFORE : \(labelViewWidth.constant) : position : \(position)")
            let width = value.width(withConstrainedHeight: labelViewHeight.constant, font: UIFont.boldSystemFont(ofSize: 13.0))
            if width + 40.0 > labelViewWidth.constant{
                labelViewWidth.constant = width + 40.0
            }
            CommonMethods.showLog(tag: TAG, message: "AFTER : \(labelViewWidth.constant)")
            categoryName.text = value
        }else{
            categoryName.text = ""
        }
        categoryImage.sd_setImage(with: URL(string: data?.categoryUrl ?? "" )) { (image, error, cacheType, url) in
        }
        labelView.roundCorners(corners: [.topLeft], radius: 30.0)
    }
    
    @IBAction func viewDetailPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: "ViewDetail", position: position)
    }
    
}
