//
//  RateOrderQuestionTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 20/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import Cosmos

class RateOrderQuestionTVC: UITableViewCell {

    let TAG = "RateOrderQuestionTVC"
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 20.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        CommonMethods.setRatingStarStyle(ratingView: ratingView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : OrderFeedbackQuestionDetail?, delegate : RatingChangeDelegate?, position : Int) {
        CommonMethods.showLog(tag: self.TAG, message: "position : \(position)")
        CommonMethods.showLog(tag: self.TAG, message: "rating : \(data?.rating ?? 0.0)")
        questionLabel.text = data?.question
        ratingView.rating = data?.rating ?? 0.0
        ratingView.didFinishTouchingCosmos = { rating in
            CommonMethods.showLog(tag: self.TAG, message: "didFinishTouchingCosmos rating : \(rating)")
            CommonMethods.showLog(tag: self.TAG, message: "position : \(position)")
            delegate?.onRatingChanged(position: position, rating: rating)
        }
    }
    
}
