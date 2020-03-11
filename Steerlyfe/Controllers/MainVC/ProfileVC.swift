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
    
    @IBOutlet weak var messageIndicatorView: UIImageView!
    @IBOutlet weak var lifetimeSavingLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouriteDetailView: UIView!
    @IBOutlet weak var savedContentDetailView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var messageDetailView: UIView!
    @IBOutlet weak var ordersDetailView: UIView!
    @IBOutlet weak var addressDetailView: UIView!
    @IBOutlet weak var nameEmailBackView: UIView!
    @IBOutlet weak var savingsFirstView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageIndicatorView.isHidden = true
        lifetimeSavingLabel.textColor = UIColor.myGreyColor
        CommonMethods.addCardViewStyle(uiView: savingsFirstView, cornerRadius: 10.0, shadowColor: UIColor.gray)
        let fillColor = UIColor.colorPrimaryDarkTrans
        let borderColor = UIColor.myLineColor
        CommonMethods.addRoundCornerFilled(uiview: nameEmailBackView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerStrokeFill(uiview: messageDetailView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerStrokeFill(uiview: ordersDetailView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerStrokeFill(uiview: addressDetailView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerStrokeFill(uiview: favouriteDetailView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerStrokeFill(uiview: savedContentDetailView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)
        CommonMethods.addRoundCornerStrokeFill(uiview: logoutView, borderWidth: 1.0, borderColor: borderColor, backgroundColor: fillColor, cornerRadius: 0.0)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = userDefault.string(forKey: MyConstants.FULL_NAME)
        emailLabel.text = userDefault.string(forKey: MyConstants.EMAIL)
    }
    
    @IBAction func logout(_ sender: Any) {
        CommonAlertMethods.showConfirmationAlert(navigationController: navigationController, title: MyConstants.APP_NAME, message: "Do you want to logout?", yesText: "Logout",noString: "Cancel", delegate: self)
    }
    
    func onConfirmationButtonPressed(yesPressed: Bool) {
        if yesPressed{
            CommonMethods.logout(navigationController: navigationController)
        }
    }
    
    @IBAction func accountInfoPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "accountInfoPressed")
        MyNavigations.goToAccountInfo(navigationController: navigationController)
    }
    
    @IBAction func messagesButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "messagesButtonPressed")
    }
    
    @IBAction func ordersButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "ordersButtonPressed")
        MyNavigations.goToOrderHistory(navigationController: navigationController)
    }
    
    @IBAction func addressButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "addressButtonPressed")
        MyNavigations.goToAddressList(navigationController: navigationController, calledForChoose: false, delegate: nil)
    }
    
    @IBAction func favouriteProductsPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "favouriteProductsPressed")
        MyNavigations.goToFavouriteProducts(navigationController: navigationController)
    }
    @IBAction func savedContentPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "savedContentPressed")
        MyNavigations.goToSavedPosts(navigationController: navigationController)
    }
}
