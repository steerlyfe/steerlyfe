//
//  PostImageVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 21/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class PostImageVC: UIViewController {
    
    var imageUrl : String?
    
    @IBOutlet weak var mainInnerView: UIView!
    @IBOutlet var mainOuterView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethods.addRoundCornerFilled(uiview: mainOuterView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 20.0)
        CommonMethods.addRoundCornerFilled(uiview: mainInnerView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 20.0)
        CommonMethods.makeRoundImageView(imageView: postImage, cornerRadius: 20.0)
        postImage.sd_setImage(with: URL(string: imageUrl ?? ""), placeholderImage: UIImage(named: "place_holder")) { (image, error, cacheType, url) in
        }
    }
    
}
