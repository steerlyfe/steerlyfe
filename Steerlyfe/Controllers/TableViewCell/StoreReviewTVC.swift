//
//  StoreReviewTVC.swift
//  Steerlyfe
//
//  Created by nap on 04/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class StoreReviewTVC: UITableViewCell {
    
    let TAG = "StoreReviewTVC"
    
    var data : ReviewDetail?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabeImage: UIImageView!
    @IBOutlet weak var nameLabelView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.common.setRatingStarStyle(ratingView: ratingView)
        nameLabel.textColor = UIColor.white
        CommonMethods.common.makeRoundImageView(imageView: nameLabeImage, cornerRadius: 30.0)
        CommonMethods.common.makeRoundImageView(imageView: profilePic, cornerRadius: 30.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : ReviewDetail?)  {
        self.data = data
        ratingView.rating = data?.rating ?? 0.0
        infoLabel.text = "By \(data?.full_name ?? "") on \(CommonMethods.common.getOnlyDate(timeStamp: data?.rating_time ?? NSDate().timeIntervalSince1970))"
        reviewDesc.text = data?.description
        if let imageUrl = data?.image_url{
            if imageUrl == ""{
                checkAndShowName()
            }else{
                nameLabelView.isHidden = true
                profilePic.isHidden = false
                profilePic.sd_setImage(with: URL(string: data?.image_url ?? "" )) { (image, error, cacheType, url) in
                    CommonMethods.common.showLog(tag: self.TAG, message: "error : \(error)")
                }
            }
        }else{
            checkAndShowName()
        }
    }
    
    func checkAndShowName() {
        nameLabelView.isHidden = false
        profilePic.isHidden = true
        let name =  data?.full_name ?? MyConstants.APP_NAME
        var components = name.components(separatedBy: " ")
        if(components.count > 0)
        {
            let firstName = components.removeFirst()
            let lastName = components.joined(separator: " ")
            if let firstLetter = firstName.first{
                if let secondLetter = lastName.first{
                    nameLabel.text = "\(firstLetter.uppercased()) \(secondLetter.uppercased())"
                }else{
                    nameLabel.text = "\(firstLetter)"
                }
            }else{
                nameLabel.text = ""
            }
        }else{
            nameLabel.text = ""
        }
    }
}
