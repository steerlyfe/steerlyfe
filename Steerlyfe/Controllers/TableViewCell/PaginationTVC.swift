//
//  PaginationTVC.swift
//  Steerlyfe
//
//  Created by nap on 03/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class PaginationTVC: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.colorPrimary
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail() {
        activityIndicator.startAnimating()
    }
}
