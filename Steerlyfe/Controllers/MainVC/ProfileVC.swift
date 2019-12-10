//
//  ProfileVC.swift
//  Steerlyfe
//
//  Created by nap on 29/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, ConfirmationDialogDelegate {
    
    let TAG = "ProfileVC"
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var projectedSavingLabel: UILabel!
    @IBOutlet weak var lifetimeSavingLabel: UILabel!
    @IBOutlet weak var emailBackView: UIView!
    @IBOutlet weak var nameBackView: UIView!
    @IBOutlet weak var nameEmailCenterView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouriteDetailView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var messageDetailView: UIView!
    @IBOutlet weak var nameEmailBackView: UIView!
    @IBOutlet weak var savingsSecondView: UIView!
    @IBOutlet weak var savingsFirstView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifetimeSavingLabel.textColor = UIColor.myGreyColor
        projectedSavingLabel.textColor = UIColor.myGreyColor        
        nameBackView.backgroundColor = UIColor.colorPrimaryDarkTrans
        nameEmailCenterView.backgroundColor = UIColor.myLineColor
        emailBackView.backgroundColor = UIColor.colorPrimaryDarkTrans
        CommonMethods.common.addCardViewStyle(uiView: savingsFirstView, cornerRadius: 10.0, shadowRadius: 10.0)
        CommonMethods.common.addCardViewStyle(uiView: savingsSecondView, cornerRadius: 10.0, shadowRadius: 10.0)
        CommonMethods.common.addRoundCornerStroke(uiview: nameEmailBackView, borderWidth: 1.0, borderColor: UIColor.myLineColor, cornerRadius: 0.0)
        CommonMethods.common.addRoundCornerStrokeFill(uiview: messageDetailView, borderWidth: 1.0, borderColor: UIColor.myLineColor, backgroundColor: UIColor.colorPrimaryDarkTrans, cornerRadius: 0.0)
        CommonMethods.common.addRoundCornerStrokeFill(uiview: favouriteDetailView, borderWidth: 1.0, borderColor: UIColor.myLineColor, backgroundColor: UIColor.colorPrimaryDarkTrans, cornerRadius: 0.0)
        CommonMethods.common.addRoundCornerStrokeFill(uiview: logoutView, borderWidth: 1.0, borderColor: UIColor.myLineColor, backgroundColor: UIColor.colorPrimaryDarkTrans, cornerRadius: 0.0)
        nameLabel.text = userDefault.string(forKey: MyConstants.FULL_NAME)
        emailLabel.text = userDefault.string(forKey: MyConstants.EMAIL)
    }
    
    @IBAction func logout(_ sender: Any) {
        CommonAlertMethods.alert.showConfirmationAlert(navigationController: navigationController, title: MyConstants.APP_NAME, message: "Do you want to logout?", yesText: "Logout",noString: "Cancel", delegate: self)
    }
    
    func onConfirmationButtonPressed(yesPressed: Bool) {
        if yesPressed{
            CommonMethods.common.logout(navigationController: navigationController)
        }
    }
}
