//
//  CommonWebServices.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import Foundation
import UIKit
import KVNProgress
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import ObjectMapper

class CommonWebServices {
    static let api : CommonWebServices = CommonWebServices()
    let baseUrl : URL = URL(string: MyConstants.API_BASE_URL)!
    let TAG : String = "CommonWebServices"
    let decoder = JSONDecoder()
    let userDefaults = UserDefaults.standard
    
    var headers : HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    private init() {
    }
    
    func setHeader()  {
        if userDefaults.bool(forKey: MyConstants.LOGIN_STATUS){
            self.headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "Auth": userDefaults.string(forKey: MyConstants.AUTHORIZATION) ?? "app"
            ]
        }else{
            self.headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    func checkLoadingAndLogout(navigationController : UINavigationController?) {
        if KVNProgress.isVisible(){
            KVNProgress.dismiss {
                CommonMethods.logout(navigationController: navigationController)
            }
        }else{
            CommonMethods.logout(navigationController: navigationController)
        }
    }
    
    func getStaticData(delegate : OnProcessCompleteDelegate) {
        Alamofire.request( URL(string: "getStaticData.php", relativeTo: baseUrl)!, method: .get, encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<GetStaticDataResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getStaticData Response AA gya")
                if responseBody.result.isSuccess {
                    let body : GetStaticDataResponse = responseBody.result.value!
                    CommonMethods.showLog(tag: self.TAG, message: "getStaticData Status \(body.status )")
                    switch(body.status){
                    case "1":
                        let databaseMethods = DatabaseMethods()
                        databaseMethods.deleteAllCategories()
                        databaseMethods.deleteAllCountries()
                        databaseMethods.deleteAllQuizQuestions()
                        body.categoriesList.forEach({ (data : CategoryDetail) in
                            databaseMethods.addNewCategory(categoryDetail: data)
                        })
                        body.countriesList.forEach({ (data : CountryDetail) in
                            databaseMethods.addNewCountry(countryDetail: data)
                        })
                        body.quizQuestions.forEach({ (data : QuizQuestionDetail) in
                            databaseMethods.addNewQuizQuestion(data: data)
                        })
                        delegate.onProcessComplete(type: "GetStaticData", status: "1", message: body.message)
                        break
                    default:
                        delegate.onProcessComplete(type: "GetStaticData", status: "0", message: body.message)
                        break
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "Error \(responseBody.result.error!)")
                    delegate.onProcessComplete(type: "GetStaticData", status: "0", message: MyConstants.STATIC_ERROR_MESSAGE)
                }
        }
    }
    
    func login(navigationController : UINavigationController?, callingCode : String, phoneNumber : String) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["phone_number":phoneNumber,
                                "calling_code":callingCode,
                                "fcm_token":self.userDefaults.string(forKey: MyConstants.FCM_TOKEN) ?? "",
                                "api_token": MyConstants.API_TOKEN_LOGIN,
                                "called_from": "ios"
        ]
        CommonMethods.showLog(tag: TAG, message: "login : \(para)")
        Alamofire.request( URL(string: "login.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<LoginResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "signup Response AA gya")
                if responseBody.result.isSuccess {
                    let body : LoginResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "signup STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            KVNProgress.dismiss(completion: {
                                self.saveUserDataGoToHome(navigationController: navigationController, userDetail: body.userDetail)
                            })
                            break
                        case "0":
                            KVNProgress.dismiss(completion: {
                                MyNavigations.goToSignup(navigationController: navigationController, callingCode: callingCode, phoneNumber: phoneNumber)
                            })
                            break
                        default:
                            KVNProgress.dismiss(completion: {
                                MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                            })
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "STATUS IS NULL")
                        KVNProgress.dismiss(completion: {
                            MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                        })
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "Error \(responseBody.result.error!)")
                    KVNProgress.dismiss(completion: {
                        MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    })
                }
        }
    }
    
    func signup(navigationController : UINavigationController?, callingCode : String, phoneNumber : String, name : String, email : String) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["phone_number":phoneNumber,
                                "calling_code":callingCode,
                                "name":name,
                                "email":email,
                                "fcm_token":self.userDefaults.string(forKey: MyConstants.FCM_TOKEN) ?? "",
                                "api_token": MyConstants.API_TOKEN_SIGNUP,
                                "called_from": "ios"
        ]
        CommonMethods.showLog(tag: TAG, message: "signup : \(para)")
        Alamofire.request( URL(string: "signup.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<LoginResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "signup Response AA gya")
                if responseBody.result.isSuccess {
                    let body : LoginResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "signup STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            KVNProgress.dismiss(completion: {
                                self.saveUserDataGoToHome(navigationController: navigationController, userDetail: body.userDetail)
                            })
                            break
                        case "0":
                            KVNProgress.dismiss(completion: {
                                MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                            })
                            break
                        default:
                            KVNProgress.dismiss(completion: {
                                MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                            })
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "signup IS NULL")
                        KVNProgress.dismiss(completion: {
                            MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                        })
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "signup \(responseBody.result.error!)")
                    KVNProgress.dismiss(completion: {
                        MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    })
                }
        }
    }
    
    func saveUserDataGoToHome(navigationController : UINavigationController?, userDetail : UserDetail?) {
        userDefaults.set(userDetail?.userId, forKey: MyConstants.USER_ID)
        userDefaults.set(userDetail?.accountId, forKey: MyConstants.ACCOUNT_ID)
        userDefaults.set(userDetail?.fullName, forKey: MyConstants.FULL_NAME)
        userDefaults.set(userDetail?.phoneNumber, forKey: MyConstants.PHONE_NUMBER)
        userDefaults.set(userDetail?.callingCode, forKey: MyConstants.CALLING_CODE)
        userDefaults.set(userDetail?.email, forKey: MyConstants.EMAIL)
        userDefaults.set(userDetail?.authToken, forKey: MyConstants.AUTHORIZATION)
        userDefaults.set(userDetail?.sessionToken, forKey: MyConstants.SESSION_TOKEN)
        userDefaults.set(userDetail?.questionSubmitted, forKey: MyConstants.QUESTION_SUBMITTED)
        userDefaults.set(true, forKey: MyConstants.LOGIN_STATUS)
        //        navigationController?.popToRootViewController(animated: true)
        //        navigationController?.popViewController(animated: true)
        //        navigationController?.dismiss(animated: true, completion: nil)
        CommonMethods.getNavigationController()?.popToRootViewController(animated: true)
    }
    
    func getHomeData(navigationController : UINavigationController?, delegate : HomeDataDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? ""
        ]
        CommonMethods.showLog(tag: TAG, message: "getHomeData para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getHomeData headers :\(self.headers)")
        Alamofire.request( URL(string: "getHomeData.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<HomeProductsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getHomeData Response AA gya")
                if responseBody.result.isSuccess {
                    let body : HomeProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getHomeData STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onHomeDataReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onHomeDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onHomeDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getHomeData IS NULL")
                        delegate?.onHomeDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getHomeData \(responseBody.result.error!)")
                    delegate?.onHomeDataReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
                
        }
    }
    
    func getCategoryProducts(navigationController : UINavigationController?, categoryId : String, count : Int, sortingType : String, delegate : ProductsListDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "categoryId":categoryId,
                                "count":count,
                                "sortingType":sortingType
        ]
        CommonMethods.showLog(tag: TAG, message: "getCategoryProducts para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getCategoryProducts headers :\(self.headers)")
        Alamofire.request( URL(string: "categoryProducts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getCategoryProducts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getCategoryProducts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getCategoryProducts IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getCategoryProducts \(responseBody.result.error!)")
                    delegate?.onProductListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func searchProduct(navigationController : UINavigationController?, productName : String, count : Int, delegate : ProductsListDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "productName":productName,
                                "count":count
        ]
        CommonMethods.showLog(tag: TAG, message: "searchProduct para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "searchProduct headers :\(self.headers)")
        Alamofire.request( URL(string: "searchProduct.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "searchProduct Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "searchProduct STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "searchProduct IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "searchProduct \(responseBody.result.error!)")
                    delegate?.onProductListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func getStoreProducts(navigationController : UINavigationController?, storeId : String, subStoreId : String, count : Int, delegate : ProductsListDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "storeId":storeId,
                                "subStoreId":subStoreId,
                                "count":count
        ]
        CommonMethods.showLog(tag: TAG, message: "getStoreProducts para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getStoreProducts headers :\(self.headers)")
        Alamofire.request( URL(string: "getSubStoreProducts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getStoreProducts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getStoreProducts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getStoreProducts IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getStoreProducts \(responseBody.result.error!)")
                    delegate?.onProductListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func getNearbyStores(navigationController : UINavigationController?, lat : Double, lng : Double, delegate : NearbyStoresDelegate?) {
        setHeader()
        let para: Parameters = [
            "userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
            "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
            "lat":lat,
            "lng":lng
        ]
        CommonMethods.showLog(tag: TAG, message: "getNearbyStores para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getNearbyStores headers :\(self.headers)")
        Alamofire.request( URL(string: "getNearbyStores.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<NearbyStoresResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getNearbyStores Response AA gya")
                if responseBody.result.isSuccess {
                    let body : NearbyStoresResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getNearbyStores STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onNearbyStoresListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onNearbyStoresListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onNearbyStoresListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getNearbyStores IS NULL")
                        delegate?.onNearbyStoresListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getNearbyStores \(responseBody.result.error!)")
                    delegate?.onNearbyStoresListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func getStoreDetail(navigationController : UINavigationController?, subStoreId : String, delegate : StoreDetailDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "subStoreId":subStoreId
        ]
        CommonMethods.showLog(tag: TAG, message: "getStoreDetail para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getStoreDetail headers :\(self.headers)")
        Alamofire.request( URL(string: "storeDetail.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<StoreDetailResponse>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.showLog(tag: self.TAG, message: "getStoreDetail Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : StoreDetailResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "getStoreDetail STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onStoreDetailReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "0":
                                delegate?.onStoreDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onStoreDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "getStoreDetail IS NULL")
                            delegate?.onStoreDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getStoreDetail \(responseBody.result.error!)")
                        delegate?.onStoreDetailReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                })
        }
    }
    
    func submitQuizQuestions(navigationController : UINavigationController?, isSkipped : Int, quizResponse : String) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "isSkipped":isSkipped,
                                "quizResponse":quizResponse
        ]
        CommonMethods.showLog(tag: TAG, message: "submitQuizQuestions para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "submitQuizQuestions headers :\(self.headers)")
        Alamofire.request( URL(string: "submitQuizQuestions.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<StatusMessageModel>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.showLog(tag: self.TAG, message: "submitQuizQuestions Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : StatusMessageModel = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "submitQuizQuestions STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                if isSkipped == 1{
                                    self.userDefaults.set(2, forKey: MyConstants.QUESTION_SUBMITTED)
                                }else{
                                    self.userDefaults.set(1, forKey: MyConstants.QUESTION_SUBMITTED)
                                }
                                navigationController?.popToRootViewController(animated: true)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "submitQuizQuestions IS NULL")
                            MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "submitQuizQuestions \(responseBody.result.error!)")
                        MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                    }
                })
        }
    }
    
    func getProductDetail(navigationController : UINavigationController?, productId : String, delegate : ProductDetailDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "productId":productId
        ]
        CommonMethods.showLog(tag: TAG, message: "getProductDetail para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getProductDetail headers :\(self.headers)")
        Alamofire.request( URL(string: "productDetail.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<ProductDetailResponse>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.showLog(tag: self.TAG, message: "getProductDetail Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : ProductDetailResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "getProductDetail STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onProductDetailReceived(status: "1", message: body.message ?? "Product Detail", data: body)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onProductDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "getProductDetail IS NULL")
                            delegate?.onProductDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getProductDetail \(responseBody.result.error!)")
                        delegate?.onProductDetailReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                })
        }
    }
    
    func placeOrder(navigationController : UINavigationController?, total_amount : Double, discount_amount : Double, amount_paid : Double, coupon_used : String, coupon_name : String, coupon_discount : Double, coupon_id : String, coupon_count : String, address_id : String, payment_info : String, order_info : String, delegate : OnProcessCompleteDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "total_amount":total_amount,
                                "discount_amount":discount_amount,
                                "amount_paid":amount_paid,
                                "coupon_used":coupon_used,
                                "coupon_name":coupon_name,
                                "coupon_discount":coupon_discount,
                                "coupon_id":coupon_id,
                                "coupon_count":coupon_count,
                                "address_id":address_id,
                                "payment_info":payment_info,
                                "order_info":order_info
        ]
        CommonMethods.showLog(tag: TAG, message: "placeOrder para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "placeOrder headers :\(self.headers)")
        KVNProgress.show()
        Alamofire.request( URL(string: "placeOrder.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<StatusMessageModel>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.showLog(tag: self.TAG, message: "placeOrder Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : StatusMessageModel = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "placeOrder STATUS \(body.status ?? "")")
                            CommonMethods.showLog(tag: self.TAG, message: "placeOrder errorData \(body.errorData ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onProcessComplete(type: MyConstants.ORDER_PLACED, status: "1", message: "New order placed successfully")
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onProcessComplete(type: MyConstants.ORDER_PLACED, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "placeOrder IS NULL")
                            delegate?.onProcessComplete(type: MyConstants.ORDER_PLACED, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "placeOrder \(responseBody.result.error!)")
                        delegate?.onProcessComplete(type: MyConstants.ORDER_PLACED, status: "0", message: MyConstants.STATIC_ERROR_MESSAGE)
                    }
                })
        }
    }
    
    func addAddress(navigationController : UINavigationController?, calling_code : String, phone_number : String, email : String, name : String, country : String, pincode : String, address : String, locality : String, city : String, state : String, delegate : AddNewAddressDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "calling_code":calling_code,
                                "phone_number":phone_number,
                                "email":email,
                                "name":name,
                                "country":country,
                                "pincode":pincode,
                                "address":address,
                                "locality":locality,
                                "city":city,
                                "state":state
        ]
        CommonMethods.showLog(tag: TAG, message: "addAddress para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "addAddress headers :\(self.headers)")
        KVNProgress.show()
        Alamofire.request( URL(string: "addAddress.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AddAddressModel>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.showLog(tag: self.TAG, message: "addAddress Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : AddAddressModel = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "addAddress STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onAddressAdded(status: "1", message: body.message ?? "New address added successfully", addressId: body.addressId)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onAddressAdded(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, addressId: nil)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "addAddress IS NULL")
                            delegate?.onAddressAdded(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, addressId: nil)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "addAddress \(responseBody.result.error!)")
                        delegate?.onAddressAdded(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, addressId: nil)
                    }
                })
        }
    }
    
    func allAddress(navigationController : UINavigationController?, delegate : AddressListDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? ""
        ]
        CommonMethods.showLog(tag: TAG, message: "allAddress para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "allAddress headers :\(self.headers)")
        Alamofire.request( URL(string: "allAddress.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AddressListResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "allAddress Response AA gya")
                if responseBody.result.isSuccess {
                    let body : AddressListResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "allAddress STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onAddressListReceived(status: "1", message: body.message ?? "Address List", data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onAddressListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "allAddress IS NULL")
                        delegate?.onAddressListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "allAddress \(responseBody.result.error!)")
                    delegate?.onAddressListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }                
        }
    }
    
    func deleteAddress(navigationController : UINavigationController?, addressId : String, delegate : OnProcessCompleteDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "addressId":addressId
        ]
        CommonMethods.showLog(tag: TAG, message: "deleteAddress para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "deleteAddress headers :\(self.headers)")
        Alamofire.request( URL(string: "deleteAddress.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AddressListResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "deleteAddress Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : AddressListResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "deleteAddress STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onProcessComplete(type: MyConstants.DELETE_ADDRESS, status: "1", message: "Address deleted successfully")
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onProcessComplete(type: MyConstants.DELETE_ADDRESS, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "deleteAddress IS NULL")
                            delegate?.onProcessComplete(type: MyConstants.DELETE_ADDRESS, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "deleteAddress \(responseBody.result.error!)")
                        delegate?.onProcessComplete(type: MyConstants.DELETE_ADDRESS, status: "0", message: MyConstants.STATIC_ERROR_MESSAGE)
                    }
                }                
        }
    }
    
    func changeDefaultAddress(navigationController : UINavigationController?, addressId : String, delegate : OnProcessCompleteDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "addressId":addressId
        ]
        CommonMethods.showLog(tag: TAG, message: "deleteAddress para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "deleteAddress headers :\(self.headers)")
        Alamofire.request( URL(string: "changeDefaultAddress.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AddressListResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "changeDefaultAddress Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : AddressListResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "changeDefaultAddress STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onProcessComplete(type: MyConstants.MAKE_DEFAULT_ADDRESS, status: "1", message: "Default address changed successfully")
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onProcessComplete(type: MyConstants.MAKE_DEFAULT_ADDRESS, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "changeDefaultAddress IS NULL")
                            delegate?.onProcessComplete(type: MyConstants.MAKE_DEFAULT_ADDRESS, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "changeDefaultAddress \(responseBody.result.error!)")
                        delegate?.onProcessComplete(type: MyConstants.MAKE_DEFAULT_ADDRESS, status: "0", message: MyConstants.STATIC_ERROR_MESSAGE)
                    }
                }
        }
    }
    
    func orderHistory(navigationController : UINavigationController?, count : Int, delegate : OrderHistoryResponseDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "count":count
        ]
        CommonMethods.showLog(tag: TAG, message: "orderHistory para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "orderHistory headers :\(self.headers)")
        Alamofire.request( URL(string: "orderHistory.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<OrderHistoryResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "orderHistory Response AA gya")
                if responseBody.result.isSuccess {
                    let body : OrderHistoryResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "orderHistory STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onOrderHistoryReceived(status: "1", message: "Order History", data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onOrderHistoryReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "orderHistory IS NULL")
                        delegate?.onOrderHistoryReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "orderHistory \(responseBody.result.error!)")
                    delegate?.onOrderHistoryReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func getAllPreviousOrderedProducts(navigationController : UINavigationController?, delegate : ProductsListDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? ""
        ]
        CommonMethods.showLog(tag: TAG, message: "getAllPreviousOrderedProducts para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getAllPreviousOrderedProducts headers :\(self.headers)")
        Alamofire.request( URL(string: "getAllPreviousOrderedProducts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getAllPreviousOrderedProducts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getAllPreviousOrderedProducts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getAllPreviousOrderedProducts IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getAllPreviousOrderedProducts \(responseBody.result.error!)")
                    delegate?.onProductListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func getOrderFeedbackQuestions(navigationController : UINavigationController?, delegate : OrderFeedbackQuestionsDelegate?) {
        setHeader()
        KVNProgress.show()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? ""
        ]
        CommonMethods.showLog(tag: TAG, message: "getOrderFeedbackQuestions para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getOrderFeedbackQuestions headers :\(self.headers)")
        Alamofire.request( URL(string: "getOrderFeedbackQuestions.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<OrderFeedbackQuestionsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getOrderFeedbackQuestions Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : OrderFeedbackQuestionsResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "getOrderFeedbackQuestions STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onOrderFeedbackQuestionReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "0":
                                delegate?.onOrderFeedbackQuestionReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onOrderFeedbackQuestionReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "getOrderFeedbackQuestions IS NULL")
                            delegate?.onOrderFeedbackQuestionReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getOrderFeedbackQuestions \(responseBody.result.error!)")
                        delegate?.onOrderFeedbackQuestionReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }
                
        }
    }
    
    func submitOrderReview(navigationController : UINavigationController?, order_id : String, order_reviews : String, delegate : OnProcessCompleteDelegate?) {
        setHeader()
        KVNProgress.show()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "order_id":order_id,
                                "order_reviews":order_reviews
        ]
        CommonMethods.showLog(tag: TAG, message: "submitOrderReview para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "submitOrderReview headers :\(self.headers)")
        Alamofire.request( URL(string: "submitOrderReview.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<StatusMessageModel>) in
                CommonMethods.showLog(tag: self.TAG, message: "submitOrderReview Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : StatusMessageModel = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "submitOrderReview STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "1", message: body.message ?? "Review submitted successfully")
                                break
                            case "0":
                                delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "submitOrderReview IS NULL")
                            delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "submitOrderReview \(responseBody.result.error!)")
                        delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "0", message: MyConstants.STATIC_ERROR_MESSAGE)
                    }
                }
                
        }
    }
    
    func getPosts(navigationController : UINavigationController?, categoryId : String, count : Int, delegate : AllPostsDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "categoryId":categoryId,
                                "count":count
        ]
        CommonMethods.showLog(tag: TAG, message: "getPosts para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getPosts headers :\(self.headers)")
        Alamofire.request( URL(string: "getPosts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AllPostsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getPosts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : AllPostsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getPosts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onPostDataReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onPostDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onPostDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getPosts IS NULL")
                        delegate?.onPostDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getPosts \(responseBody.result.error!)")
                    delegate?.onPostDataReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func getSavedPosts(navigationController : UINavigationController?, count : Int, delegate : AllPostsDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "count":count
        ]
        CommonMethods.showLog(tag: TAG, message: "getSavedPosts para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getSavedPosts headers :\(self.headers)")
        Alamofire.request( URL(string: "getSavedPosts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AllPostsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getSavedPosts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : AllPostsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "getSavedPosts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onPostDataReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onPostDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                            break
                        case "10":
                            self.checkLoadingAndLogout(navigationController: navigationController)
                            break
                        default:
                            delegate?.onPostDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                            break
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getSavedPosts IS NULL")
                        delegate?.onPostDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "getSavedPosts \(responseBody.result.error!)")
                    delegate?.onPostDataReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                }
        }
    }
    
    func updatePostViews(postIds : String) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "postIds":postIds
        ]
        CommonMethods.showLog(tag: TAG, message: "updatePostViews para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "updatePostViews headers :\(self.headers)")
        Alamofire.request( URL(string: "updatePostViews.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AllPostsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "updatePostViews Response AA gya")
                if responseBody.result.isSuccess {
                    let body : AllPostsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "updatePostViews STATUS \(body.status ?? "")")
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "updatePostViews IS NULL")
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "updatePostViews \(responseBody.result.error!)")
                }
        }
    }
    
    
    func savePost(post_id : String, action : String) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "post_id":post_id,
                                "action":action
        ]
        CommonMethods.showLog(tag: TAG, message: "savePost para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "savePost headers :\(self.headers)")
        Alamofire.request( URL(string: "savePost.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AllPostsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "savePost Response AA gya")
                if responseBody.result.isSuccess {
                    let body : AllPostsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.showLog(tag: self.TAG, message: "savePost STATUS \(body.status ?? "")")
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "savePost IS NULL")
                    }
                }else{
                    CommonMethods.showLog(tag: self.TAG, message: "savePost \(responseBody.result.error!)")
                }
        }
    }
    
    func updateProfileInfo(navigationController : UINavigationController?, name : String, email : String) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "name":name,
                                "email":email
        ]
        CommonMethods.showLog(tag: TAG, message: "updateProfileInfo para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "updateProfileInfo headers :\(self.headers)")
        Alamofire.request( URL(string: "updateProfileInfo.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<LoginResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "updateProfileInfo Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : LoginResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "updateProfileInfo STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                self.userDefaults.set(name, forKey: MyConstants.FULL_NAME)
                                self.userDefaults.set(email, forKey: MyConstants.EMAIL)
                                KVNProgress.showSuccess(withStatus: body.message) {
                                    CommonMethods.dismissCurrentViewController()
                                }
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "updateProfileInfo IS NULL")
                            MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "updateProfileInfo \(responseBody.result.error!)")
                        MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    }
                }
        }
    }
    
    func getProductDetailWithBarcode(navigationController : UINavigationController?, barcode : String, delegate : ProductsListDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "barcode":barcode
        ]
        CommonMethods.showLog(tag: TAG, message: "getProductDetailWithBarcode para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getProductDetailWithBarcode headers :\(self.headers)")
        Alamofire.request( URL(string: "getProductDetailWithBarcode.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getProductDetailWithBarcode Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : CategoryProductsResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "getProductDetailWithBarcode STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "0":
                                delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "getProductDetailWithBarcode IS NULL")
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getProductDetailWithBarcode \(responseBody.result.error!)")
                        delegate?.onProductListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }                
        }
    }
        
    func searchProduct(navigationController : UINavigationController?, name : String, lat : Double, lng : Double, myLocationAvailable : Bool, delegate : CommonSearchDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "name":name,
                                "count":0,
                                "lat":lat,
                                "lng":lng,
                                "latLngExists":myLocationAvailable ? 1 : 0
        ]
        CommonMethods.showLog(tag: TAG, message: "searchProduct para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "searchProduct headers :\(self.headers)")
        Alamofire.request( URL(string: "searchProduct.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CommonSearchResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "searchProduct Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : CommonSearchResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "searchProduct STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onSearchResultReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onSearchResultReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "searchProduct IS NULL")
                            delegate?.onSearchResultReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "searchProduct \(responseBody.result.error!)")
                        delegate?.onSearchResultReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }
        }
    }
    
    func getCouponList(navigationController : UINavigationController?, storeIdsJsonString : String, delegate : CouponsListDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "store_id_list":storeIdsJsonString
        ]
        CommonMethods.showLog(tag: TAG, message: "getCouponList para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "getCouponList headers :\(self.headers)")
        Alamofire.request( URL(string: "getCouponList.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<AllCouponsListResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "getCouponList Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : AllCouponsListResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "getCouponList STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onCouponsListReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                delegate?.onCouponsListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "getCouponList IS NULL")
                            delegate?.onCouponsListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "getCouponList \(responseBody.result.error!)")
                        delegate?.onCouponsListReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }
        }
    }

    func checkCouponWithOrder(navigationController : UINavigationController?, coupon_id : String, delegate : ApplyCouponDelegate?, closeViewController : Bool) {
        setHeader()
        let databaseMethods = DatabaseMethods()
        let cartProducts = databaseMethods.getAllCartProducts()
        var jsonCollection = [Any]()
        for loopValue in cartProducts {
            if let productId = loopValue.product_id{
                jsonCollection.append(productId)
            }
        }
        let orderInfoJsonString = CommonMethods.prepareJson(from: jsonCollection) ?? "[]"
        CommonMethods.showLog(tag: TAG, message: "orderInfoJsonString : \(orderInfoJsonString)")
        let totalAmount = CommonMethods.getTotalPrice(data: cartProducts)
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "total_amount":totalAmount,
                                "order_info":orderInfoJsonString,
                                "coupon_id":coupon_id
        ]
        CommonMethods.showLog(tag: TAG, message: "checkCouponWithOrder para : \(para)")
        CommonMethods.showLog(tag: TAG, message: "checkCouponWithOrder headers :\(self.headers)")
        KVNProgress.show()
        Alamofire.request( URL(string: "checkCouponWithOrder.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<ApplyCouponResponse>) in
                CommonMethods.showLog(tag: self.TAG, message: "checkCouponWithOrder Response AA gya")
                KVNProgress.dismiss {
                    if responseBody.result.isSuccess {
                        let body : ApplyCouponResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.showLog(tag: self.TAG, message: "checkCouponWithOrder STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                body.couponId = coupon_id
                                if closeViewController{
                                    KVNProgress.showSuccess(withStatus: "Coupon applied successfully") {
                                        delegate?.onCouponApplied(applyCouponResponse: body)
                                        CommonMethods.dismissCurrentViewController()
                                    }
                                }else{
                                    delegate?.onCouponApplied(applyCouponResponse: body)
                                }
                                break
                            case "0":
                                if closeViewController{
                                    MyNavigations.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                                }else{
                                    delegate?.onCouponApplied(applyCouponResponse: body)
                                }
                                break
                            case "10":
                                self.checkLoadingAndLogout(navigationController: navigationController)
                                break
                            default:
                                MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                                break
                            }
                        }else{
                            CommonMethods.showLog(tag: self.TAG, message: "checkCouponWithOrder IS NULL")
                            MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                        }
                    }else{
                        CommonMethods.showLog(tag: self.TAG, message: "checkCouponWithOrder \(responseBody.result.error!)")
                        MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
                    }
                }
        }
    }
}
