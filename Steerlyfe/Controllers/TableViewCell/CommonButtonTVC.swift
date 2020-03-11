//
//  CommonButtonTVC.swift
//  Steerlyfe
//
//  Created by nap on 04/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class CommonButtonTVC: UITableViewCell {

    var delegate : ButtonPressedDelegate?
    var type : String = ""
    
    @IBOutlet weak var buttonView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addRoundCornerFilled(uiview: buttonView, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: buttonView.frame.height / 2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(title : String, type : String, delegate : ButtonPressedDelegate?) {
        self.delegate = delegate
        self.type = type
        buttonView.setTitle(title, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: type)
    }
}
