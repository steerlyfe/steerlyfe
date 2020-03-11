//
//  SortingOptionTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 10/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class SortingOptionTVC: UITableViewCell {

    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : SortingOptions, selectedType : SortingType?, delegate : ButtonPressedAtPositionDelegate?, position : Int) {
        self.delegate = delegate
        self.position = position
        nameLabel.text = data.sortingName
        if selectedType == data.sortingType{
            selectedIcon.isHidden = false
        }else{
            selectedIcon.isHidden = true
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.ITEM_SELECTED, position: position)
    }
    
}
