//
//  MyNavigations.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//
import UIKit
import PopupDialog

class MyNavigations {
    
    let TAG  = "MyNavigations"
    static let navigation = MyNavigations()
    
    func goToSplash(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToLogin(navigationController : UINavigationController?, calledFrom : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            viewController.calledFrom = calledFrom
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToChooseCountry(navigationController : UINavigationController?, pageTitle : String, countrySelectionDelegate : CountrySelectionDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseCountryVC") as? ChooseCountryVC {
            viewController.pageTitle = pageTitle
            viewController.countrySelectionDelegate = countrySelectionDelegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToVerifyOtp(navigationController : UINavigationController?, phoneNumber : String, verificationID : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyOtpVC") as? VerifyOtpVC {
            viewController.phoneNumber = phoneNumber
            viewController.verificationID = verificationID
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToSignup(navigationController : UINavigationController?, phoneNumber : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC") as? SignupVC {
            viewController.phoneNumber = phoneNumber
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func goToMain(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToProductList(navigationController : UINavigationController?, type : ProductListType, pageTitle : String, categoryId : String, subStoreId : String, storeId : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as? ProductListVC {
            viewController.type = type
            viewController.pageTitle = pageTitle
            viewController.categoryId = categoryId
            viewController.subStoreId = subStoreId
            viewController.storeId = storeId
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToNearbyStores(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearbyStoresVC") as? NearbyStoresVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToStoreDetail(navigationController : UINavigationController?, subStoreId : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreDetailVC") as? StoreDetailVC {
            viewController.subStoreId = subStoreId
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showCommonMessageDialog(message : String, buttonTitle : String){
        if let navigationController = CommonMethods.common.getNavigationController() {
            if let dialogView = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "CommonMessageDialog") as? CommonMessageDialog {
                dialogView.titleText = message
                dialogView.buttonTitle = buttonTitle
                showDialog(navigationController: navigationController, dialogView: dialogView)
            }
        }
    }
    
    private func showDialog(navigationController : UINavigationController?, dialogView : UIViewController){
        let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
        
        let containterView = PopupDialogContainerView.appearance()
        containterView.backgroundColor = .clear
        
        let overlayView = PopupDialogOverlayView.appearance()
        overlayView.blurEnabled = false
        popupDialog.transitionStyle = PopupDialogTransitionStyle.bounceUp
        navigationController?.present(popupDialog, animated: true, completion: nil)
    }
    
    
}
