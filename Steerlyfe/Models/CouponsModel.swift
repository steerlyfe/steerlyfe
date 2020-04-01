//
//  CouponsModel.swift
//  Steerlyfe
//
//  Created by Nap Works on 30/03/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import ObjectMapper

class AllCouponsListResponse: Mappable {
    var status : String?
    var message : String?
    var couponList : [CouponDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        couponList <- map["couponList"]
    }
}

class CouponDetail : Mappable {
    var couponId : String?
    var couponCode : String?
    var couponStartTime : Double?
    var couponEndTime : Double?
    var couponType : String?
    var discountType : String?
    var currentStatus : String?
    var discountPercentage : Double?
    var discountPercentageUptoAmount : Double?
    var usedbyCountOrEndDate : String?
    var numberOfCoupon : Int?
    var totalUsedCoupon : Int?
    var discountAmount : Double?
    var moreThenAmount : Double?
    var createdTime : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        couponId <- map["couponId"]
        couponCode <- map["couponCode"]
        couponStartTime <- map["couponStartTime"]
        couponEndTime <- map["couponEndTime"]
        couponType <- map["couponType"]
        discountType <- map["discountType"]
        currentStatus <- map["currentStatus"]
        discountPercentage <- map["discountPercentage"]
        discountPercentageUptoAmount <- map["discountPercentageUptoAmount"]
        usedbyCountOrEndDate <- map["usedbyCountOrEndDate"]
        numberOfCoupon <- map["numberOfCoupon"]
        totalUsedCoupon <- map["totalUsedCoupon"]
        discountAmount <- map["discountAmount"]
        moreThenAmount <- map["moreThenAmount"]
        createdTime <- map["createdTime"]
    }
}

class ApplyCouponResponse: Mappable {
    var status : String?
    var message : String?
    var payableAmountAfterDiscount : Double?
    var couponCountCheck : String?
    var discountAmount : Double?
    var couponCode : String?
    
    var couponId : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        payableAmountAfterDiscount <- map["payableAmountAfterDiscount"]
        couponCountCheck <- map["couponCountCheck"]
        discountAmount <- map["discountAmount"]
        couponCode <- map["couponCode"]
    }
}
