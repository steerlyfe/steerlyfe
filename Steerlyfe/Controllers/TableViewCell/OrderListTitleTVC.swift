//
//  OrderListTitleTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderListTitleTVC: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(title : String)  {
        titleLabel.text = title
    }
    
}
