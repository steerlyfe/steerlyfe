//
//  ProductCommonTitleTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 13/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class ProductCommonTitleTVC: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(title : String) {
        titleLabel.text = title
    }
}
