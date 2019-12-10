//
//  CommonMessageDialogViewController.swift
//  Steerlyfe
//
//  Created by nap on 26/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class CommonMessageDialog: UIViewController {
    
    let TAG  = "CommonMessageDialog"
    
    var titleText: String = ""
    var buttonTitle : String = ""
    
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = titleText
        commonButton.setTitleColor(UIColor.colorPrimaryDark, for: .normal)
        commonButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func commonButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
