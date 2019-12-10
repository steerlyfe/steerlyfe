//
//  CommonAlertMethods.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class CommonAlertMethods {
    
    let TAG = "CommonAlertMethods"
    static let alert = CommonAlertMethods()
    
    func showConfirmationAlert(navigationController : UINavigationController?, title : String, message : String, yesText : String, noString : String, delegate : ConfirmationDialogDelegate) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: yesText, style: UIAlertAction.Style.default, handler: { (data) in
            delegate.onConfirmationButtonPressed(yesPressed: true)
        }))
        alert.addAction(UIAlertAction(title: noString, style: UIAlertAction.Style.default, handler: { (data) in
            delegate.onConfirmationButtonPressed(yesPressed: false)
        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

