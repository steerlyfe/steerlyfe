//
//  CountryListTableViewCell.swift
//  Steerlyfe
//
//  Created by nap on 26/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    var buttonDelegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var calligCodeLabel: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var longCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        longCode.textColor = UIColor.colorPrimaryDark
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDetail(data : CountryDetail, buttonDelegate : ButtonPressedAtPositionDelegate?, position : Int)  {
        self.buttonDelegate = buttonDelegate
        self.position = position
        longCode.text = data.longCode
        countryName.text = data.countryName
        calligCodeLabel.text = "+\(data.callingCode ?? "")"
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        buttonDelegate?.onButtonPressed(type: "CountrySelected", position: position)
    }
}
