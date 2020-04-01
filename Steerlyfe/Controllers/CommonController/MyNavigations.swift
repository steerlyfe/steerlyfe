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
    
    static let TAG  = "MyNavigations"
    static let navigation = MyNavigations()
    
    public static func goToSplash(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToLogin(navigationController : UINavigationController?, calledFrom : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            viewController.calledFrom = calledFrom
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToChooseCountry(navigationController : UINavigationController?, pageTitle : String, countrySelectionDelegate : CountrySelectionDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseCountryVC") as? ChooseCountryVC {
            viewController.pageTitle = pageTitle
            viewController.countrySelectionDelegate = countrySelectionDelegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToVerifyOtp(navigationController : UINavigationController?, callingCode : String,  phoneNumber : String, verificationID : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyOtpVC") as? VerifyOtpVC {
            viewController.phoneNumber = phoneNumber
            viewController.callingCode = callingCode
            viewController.verificationID = verificationID
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToSignup(navigationController : UINavigationController?, callingCode : String, phoneNumber : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC") as? SignupVC {
            viewController.phoneNumber = phoneNumber
            viewController.callingCode = callingCode
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToMain(navigationController : UINavigationController?) {
        //        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC {
        //            navigationController?.pushViewController(viewController, animated: true)
        //        }
        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "MainUpdatedVC") as? MainUpdatedVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToQuizQuestions(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizQuestionsVC") as? QuizQuestionsVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    public static func goToProductList(navigationController : UINavigationController?, type : ProductListType, pageTitle : String, categoryId : String, subStoreId : String, storeId : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as? ProductListVC {
            viewController.type = type
            viewController.pageTitle = pageTitle
            viewController.categoryId = categoryId
            viewController.subStoreId = subStoreId
            viewController.storeId = storeId
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToNearbyStores(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearbyStoresVC") as? NearbyStoresVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToStoreDetail(navigationController : UINavigationController?, subStoreId : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreDetailVC") as? StoreDetailVC {
            viewController.subStoreId = subStoreId
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToCategoryDetail(navigationController : UINavigationController?, categoryDetail : CategoryDetail?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryDetailVC") as? CategoryDetailVC {
            viewController.categoryDetail = categoryDetail
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToFavouriteProducts(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavouriteProductsVC") as? FavouriteProductsVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToProductDetail(navigationController : UINavigationController?, productId : String?, refreshProductsListDelegate : RefreshProductsListDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
            viewController.productId = productId ?? ""
            viewController.refreshProductsListDelegate = refreshProductsListDelegate
            navigationController?.pushViewController(viewController, animated: true)
        }else{
            CommonMethods.showLog(tag: self.TAG, message: "navigationController null")
        }
    }
    
    public static func goToCart(navigationController : UINavigationController?, showBackArrow : Bool) {
        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC {
            viewController.showBackArrow = showBackArrow
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToOrderHistory(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderHistoryVC") as? OrderHistoryVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToOrderDetail(navigationController : UINavigationController?, orderDetail : OrderDetail?, delegate : OnProcessCompleteDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailVC") as? OrderDetailVC {
            viewController.orderDetail = orderDetail
            viewController.delegate = delegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToAddressList(navigationController : UINavigationController?, calledForChoose : Bool, delegate : ChooseAddressDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressListVC") as? AddressListVC {
            viewController.calledForChoose = calledForChoose
            viewController.delegate = delegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToAddAddress(navigationController : UINavigationController?, delegate : ChooseAddressDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
            viewController.delegate = delegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToPreviousOrderProducts(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviousOrderProductsVC") as? PreviousOrderProductsVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToCouponList(navigationController : UINavigationController?, applyCouponDelegate : ApplyCouponDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CouponListVC") as? CouponListVC {
            viewController.applyCouponDelegate = applyCouponDelegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToRateOrder(navigationController : UINavigationController?, order_id : String?, delegate : OnProcessCompleteDelegate?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RateOrderVC") as? RateOrderVC {
            viewController.order_id = order_id
            viewController.delegate = delegate
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToScanner(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScannerVC") as? ScannerVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToSavedPosts(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "SavedPostsVC") as? SavedPostsVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToAccountInfo(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "AccountInfoVC") as? AccountInfoVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public static func goToCommonProductsList(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommonProductsListVC") as? CommonProductsListVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
        
    public static func goToCommonProductsList(navigationController : UINavigationController?, listData : [ProductDetail], pageTitle : String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommonProductsListVC") as? CommonProductsListVC {
            viewController.pageTitle = pageTitle
            viewController.listData = listData
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
//    public static func goToCombinedSearch(uiViewController : UIViewController?, navigationController : UINavigationController?) {
//        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "CombinedSearchVC") as? CombinedSearchVC {
//            viewController.modalPresentationStyle = .overFullScreen
//            viewController.navController = navigationController
//            uiViewController?.present(viewController, animated: false, completion: nil)
//        }
//    }
    
    public static func goToCombinedSearch(navigationController : UINavigationController?) {
        if let viewController = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "CombinedSearchVC") as? CombinedSearchVC {
//            viewController.modalPresentationStyle = .overFullScreen
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    public static func showCommonMessageDialog(message : String, buttonTitle : String){
        if let navigationController = CommonMethods.getNavigationController() {
            if let dialogView = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "CommonMessageDialog") as? CommonMessageDialog {
                dialogView.titleText = message
                dialogView.buttonTitle = buttonTitle
                showDialog(navigationController: navigationController, dialogView: dialogView)
            }
        }
    }
    
    public static func showSortingOptionsDialog(navigationController : UINavigationController?, selectedType : SortingType?, delegate : SortingOptionDelegate?){
        if let dialogView = UIStoryboard(name: "Dialogs", bundle: nil).instantiateViewController(withIdentifier: "SortingOptionsDialog") as? SortingOptionsDialog {
            dialogView.selectedType = selectedType
            dialogView.delegate = delegate
            showDialog(navigationController: navigationController, dialogView: dialogView)
        }
    }
    
    public static func showDialog(navigationController : UINavigationController?, dialogView : UIViewController){
        let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
        
        let containterView = PopupDialogContainerView.appearance()
        containterView.backgroundColor = .clear
        
        let overlayView = PopupDialogOverlayView.appearance()
        overlayView.blurEnabled = false
        popupDialog.transitionStyle = PopupDialogTransitionStyle.bounceUp
        navigationController?.present(popupDialog, animated: true, completion: nil)
    }
    
    
}
