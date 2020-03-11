//
//  TotalPriceTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 09/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class TotalPriceTVC: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
