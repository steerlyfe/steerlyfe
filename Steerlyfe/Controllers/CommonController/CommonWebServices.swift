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
    
    func getStaticData(delegate : OnProcessCompleteDelegate) {
        Alamofire.request( URL(string: "getStaticData.php", relativeTo: baseUrl)!, method: .get, encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<GetStaticDataResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "getStaticData Response AA gya")
                if responseBody.result.isSuccess {
                    let body : GetStaticDataResponse = responseBody.result.value!
                    CommonMethods.common.showLog(tag: self.TAG, message: "getStaticData Status \(body.status )")
                    switch(body.status){
                    case "1":
                        let databaseMethods = DatabaseMethods()
                        databaseMethods.deleteAllCategories()
                        databaseMethods.deleteAllCountries()
                        body.categoriesList.forEach({ (data : CategoryDetail) in
                            let databaseData = DatabaseCategoryDetail()
                            databaseData.categoryId = data.categoryId ?? ""
                            databaseData.categoryName = data.categoryName ?? ""
                            databaseData.categoryUrl = data.categoryUrl ?? ""
                            databaseMethods.addNewCategory(databaseCategoryDetail: databaseData)
                        })
                        body.countriesList.forEach({ (data : CountryDetail) in
                            let databaseData = DatabaseCountryDetail()
                            databaseData.countryId = data.countryId ?? ""
                            databaseData.countryName = data.countryName ?? ""
                            databaseData.shortCode = data.shortCode ?? ""
                            databaseData.longCode = data.longCode ?? ""
                            databaseData.callingCode = data.callingCode ?? ""
                            databaseData.timeZone = data.timeZone ?? ""
                            databaseMethods.addNewCountry(databaseCountryDetail: databaseData)
                        })
                        delegate.onProcessComplete(type: "GetStaticData", status: "1", message: body.message)
                        break
                    default:
                        delegate.onProcessComplete(type: "GetStaticData", status: "0", message: body.message)
                        break
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "Error \(responseBody.result.error!)")
                    delegate.onProcessComplete(type: "GetStaticData", status: "0", message: MyConstants.STATIC_ERROR_MESSAGE)
                }
        }
    }
    
    func login(navigationController : UINavigationController?, phoneNumber : String) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["phone_number":phoneNumber,
                                "fcm_token":self.userDefaults.string(forKey: MyConstants.FCM_TOKEN) ?? "",
                                "api_token": MyConstants.API_TOKEN_LOGIN,
                                "called_from": "ios"
        ]
        CommonMethods.common.showLog(tag: TAG, message: "login : \(para)")
        Alamofire.request( URL(string: "login.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<LoginResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "signup Response AA gya")
                if responseBody.result.isSuccess {
                    let body : LoginResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.common.showLog(tag: self.TAG, message: "signup STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            KVNProgress.dismiss(completion: {
                                self.saveUserDataGoToHome(navigationController: navigationController, userDetail: body.userDetail)
                            })
                            break
                        case "0":
                            KVNProgress.dismiss(completion: {
                                MyNavigations.navigation.goToSignup(navigationController: navigationController, phoneNumber: phoneNumber)
                            })
                            break
                        default:
                            KVNProgress.dismiss(completion: {
                                MyNavigations.navigation.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                            })
                            break
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "STATUS IS NULL")
                        KVNProgress.dismiss(completion: {
                            MyNavigations.navigation.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                        })
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "Error \(responseBody.result.error!)")
                    KVNProgress.dismiss(completion: {
                        MyNavigations.navigation.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    })
                }
        }
    }
    
    func signup(navigationController : UINavigationController?, phoneNumber : String, name : String, email : String) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["phone_number":phoneNumber,
                                "name":name,
                                "email":email,
                                "fcm_token":self.userDefaults.string(forKey: MyConstants.FCM_TOKEN) ?? "",
                                "api_token": MyConstants.API_TOKEN_SIGNUP,
                                "called_from": "ios"
        ]
        CommonMethods.common.showLog(tag: TAG, message: "signup : \(para)")
        Alamofire.request( URL(string: "signup.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<LoginResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "signup Response AA gya")
                if responseBody.result.isSuccess {
                    let body : LoginResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.common.showLog(tag: self.TAG, message: "signup STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            KVNProgress.dismiss(completion: {
                                self.saveUserDataGoToHome(navigationController: navigationController, userDetail: body.userDetail)
                            })
                            break
                        case "0":
                            KVNProgress.dismiss(completion: {
                                MyNavigations.navigation.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                            })
                            break
                        default:
                            KVNProgress.dismiss(completion: {
                                MyNavigations.navigation.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                            })
                            break
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "signup IS NULL")
                        KVNProgress.dismiss(completion: {
                            MyNavigations.navigation.showCommonMessageDialog(message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                        })
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "signup \(responseBody.result.error!)")
                    KVNProgress.dismiss(completion: {
                        MyNavigations.navigation.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    })
                }
        }
    }
    
    func saveUserDataGoToHome(navigationController : UINavigationController?, userDetail : UserDetail?) {
        userDefaults.set(userDetail?.userId, forKey: MyConstants.USER_ID)
        userDefaults.set(userDetail?.accountId, forKey: MyConstants.ACCOUNT_ID)
        userDefaults.set(userDetail?.fullName, forKey: MyConstants.FULL_NAME)
        userDefaults.set(userDetail?.phoneNumber, forKey: MyConstants.PHONE_NUMBER)
        userDefaults.set(userDetail?.email, forKey: MyConstants.EMAIL)
        userDefaults.set(userDetail?.authToken, forKey: MyConstants.AUTHORIZATION)
        userDefaults.set(userDetail?.sessionToken, forKey: MyConstants.SESSION_TOKEN)
        userDefaults.set(true, forKey: MyConstants.LOGIN_STATUS)
        navigationController?.popToRootViewController(animated: true)
        //        MyNavigations.navigation.goToMain(navigationController: navigationController)
    }
    
    func getHomeData(navigationController : UINavigationController?, delegate : HomeDataDelegate?) {
        KVNProgress.show()
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? ""
        ]
        CommonMethods.common.showLog(tag: TAG, message: "getHomeData para : \(para)")
        CommonMethods.common.showLog(tag: TAG, message: "getHomeData headers :\(self.headers)")
        Alamofire.request( URL(string: "getHomeData.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<HomeProductsResponse>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.common.showLog(tag: self.TAG, message: "getHomeData Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : HomeProductsResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.common.showLog(tag: self.TAG, message: "getHomeData STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onHomeDataReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "0":
                                delegate?.onHomeDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            default:
                                delegate?.onHomeDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            }
                        }else{
                            CommonMethods.common.showLog(tag: self.TAG, message: "getHomeData IS NULL")
                            delegate?.onHomeDataReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getHomeData \(responseBody.result.error!)")
                        delegate?.onHomeDataReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                })
        }
    }
    
    func getCategoryProducts(navigationController : UINavigationController?, categoryId : String, count : Int, delegate : ProductsListDelegate?) {
        setHeader()
        let para: Parameters = ["userId":self.userDefaults.string(forKey: MyConstants.USER_ID) ?? "",
                                "sessionToken":self.userDefaults.string(forKey: MyConstants.SESSION_TOKEN) ?? "",
                                "categoryId":categoryId,
                                "count":count
        ]
        CommonMethods.common.showLog(tag: TAG, message: "getCategoryProducts para : \(para)")
        CommonMethods.common.showLog(tag: TAG, message: "getCategoryProducts headers :\(self.headers)")
        Alamofire.request( URL(string: "categoryProducts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "getCategoryProducts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getCategoryProducts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getCategoryProducts IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "getCategoryProducts \(responseBody.result.error!)")
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
        CommonMethods.common.showLog(tag: TAG, message: "searchProduct para : \(para)")
        CommonMethods.common.showLog(tag: TAG, message: "searchProduct headers :\(self.headers)")
        Alamofire.request( URL(string: "searchProduct.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "searchProduct Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.common.showLog(tag: self.TAG, message: "searchProduct STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "searchProduct IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "searchProduct \(responseBody.result.error!)")
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
        CommonMethods.common.showLog(tag: TAG, message: "getStoreProducts para : \(para)")
        CommonMethods.common.showLog(tag: TAG, message: "getStoreProducts headers :\(self.headers)")
        Alamofire.request( URL(string: "getSubStoreProducts.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<CategoryProductsResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "getStoreProducts Response AA gya")
                if responseBody.result.isSuccess {
                    let body : CategoryProductsResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getStoreProducts STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onProductListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        default:
                            delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getStoreProducts IS NULL")
                        delegate?.onProductListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "getStoreProducts \(responseBody.result.error!)")
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
        CommonMethods.common.showLog(tag: TAG, message: "getNearbyStores para : \(para)")
        CommonMethods.common.showLog(tag: TAG, message: "getNearbyStores headers :\(self.headers)")
        Alamofire.request( URL(string: "getNearbyStores.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<NearbyStoresResponse>) in
                CommonMethods.common.showLog(tag: self.TAG, message: "getNearbyStores Response AA gya")
                if responseBody.result.isSuccess {
                    let body : NearbyStoresResponse = responseBody.result.value!
                    if body.status != nil{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getNearbyStores STATUS \(body.status ?? "")")
                        switch(body.status){
                        case "1":
                            delegate?.onNearbyStoresListReceived(status: "1", message: body.message ?? "", data: body)
                            break
                        case "0":
                            delegate?.onNearbyStoresListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        default:
                            delegate?.onNearbyStoresListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                            break
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getNearbyStores IS NULL")
                        delegate?.onNearbyStoresListReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                }else{
                    CommonMethods.common.showLog(tag: self.TAG, message: "getNearbyStores \(responseBody.result.error!)")
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
        CommonMethods.common.showLog(tag: TAG, message: "getStoreDetail para : \(para)")
        CommonMethods.common.showLog(tag: TAG, message: "getStoreDetail headers :\(self.headers)")
        Alamofire.request( URL(string: "storeDetail.php", relativeTo: baseUrl)!, method: .post, parameters:para , encoding: URLEncoding.default, headers: headers)
            .responseObject { (responseBody : DataResponse<StoreDetailResponse>) in
                KVNProgress.dismiss(completion: {
                    CommonMethods.common.showLog(tag: self.TAG, message: "getStoreDetail Response AA gya")
                    if responseBody.result.isSuccess {
                        let body : StoreDetailResponse = responseBody.result.value!
                        if body.status != nil{
                            CommonMethods.common.showLog(tag: self.TAG, message: "getStoreDetail STATUS \(body.status ?? "")")
                            switch(body.status){
                            case "1":
                                delegate?.onStoreDetailReceived(status: "1", message: body.message ?? "", data: body)
                                break
                            case "0":
                                delegate?.onStoreDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            default:
                                delegate?.onStoreDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                                break
                            }
                        }else{
                            CommonMethods.common.showLog(tag: self.TAG, message: "getStoreDetail IS NULL")
                            delegate?.onStoreDetailReceived(status: "0", message: body.message ?? MyConstants.STATIC_ERROR_MESSAGE, data: body)
                        }
                    }else{
                        CommonMethods.common.showLog(tag: self.TAG, message: "getStoreDetail \(responseBody.result.error!)")
                        delegate?.onStoreDetailReceived(status: "0", message: MyConstants.STATIC_ERROR_MESSAGE, data: nil)
                    }
                })
        }
    }
    
    
}
