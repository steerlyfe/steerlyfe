//
//  PaginationCVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 08/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class PaginationCVC: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.colorPrimary
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
        
    func setDetail() {
        activityIndicator.startAnimating()
    }
}
