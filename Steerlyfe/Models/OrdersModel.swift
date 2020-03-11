//
//  OrdersModel.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import ObjectMapper

class OrderHistoryResponse: Mappable {
    var status : String?
    var message : String?
    var perPageItems : Int?
    var orderList : [OrderDetail] = []
    var productList : [ProductDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        perPageItems <- map["perPageItems"]
        orderList <- map["orderList"]
        productList <- map["productList"]
    }
}

class OrderDetail: Mappable {
    var order_id : String?
    var user_id : String?
    var total_amount : Double?
    var discount_amount : Double?
    var order_rating : Double?
    var amount_paid : Double?
    var coupon_used : Bool?
    var coupon_name : String?
    var coupon_discount : Double?
    var total_savings : Double?
    var order_time : Double?
    var order_status : String?
    var address_detail : AddressDetail?
    var order_info : [OrderProductInfo] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        order_id <- map["order_id"]
        user_id <- map["user_id"]
        total_amount <- map["total_amount"]
        discount_amount <- map["discount_amount"]
        order_rating <- map["order_rating"]        
        amount_paid <- map["amount_paid"]
        coupon_used <- map["coupon_used"]
        coupon_name <- map["coupon_name"]
        coupon_discount <- map["coupon_discount"]
        total_savings <- map["total_savings"]
        order_time <- map["order_time"]
        order_status <- map["order_status"]
        address_detail <- map["address_detail"]
        order_info <- map["order_info"]
    }
}

class OrderProductInfo: Mappable {
    var product_image : String?
    var product_name : String?
    var sale_price : Double?
    var additional_feature : String?
    var store_name : String?
    var store_id : String?
    var product_availability : String?
    var sub_store_id : String?
    var additional_feature_price : Double?
    var actual_price : Double?
    var sub_store_address : String?
    var product_availability_price : Double?
    var product_id : String?
    var quantity : Int?
    var status : OrderProductStatus?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        product_image <- map["product_image"]
        product_name <- map["product_name"]
        sale_price <- map["sale_price"]
        additional_feature <- map["additional_feature"]
        store_name <- map["store_name"]
        store_id <- map["store_id"]
        product_availability <- map["product_availability"]
        sub_store_id <- map["sub_store_id"]
        additional_feature_price <- map["additional_feature_price"]
        actual_price <- map["actual_price"]
        sub_store_address <- map["sub_store_address"]
        product_availability_price <- map["product_availability_price"]
        product_id <- map["product_id"]
        quantity <- map["quantity"]
        status <- map["status"]
    }
}

class OrderProductStatus: Mappable {
    var currentStatus : String?
    var logsList : [OrderProductLogDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        currentStatus <- map["currentStatus"]
        logsList <- map["logsList"]
    }
}

class OrderProductLogDetail: Mappable {
    var type : String?
    var value : Bool?
    var time : Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        value <- map["value"]
        time <- map["time"]
    }
}

class OrderFeedbackQuestionsResponse: Mappable {
    var status : String?
    var message : String?
    var questionList : [OrderFeedbackQuestionDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        questionList <- map["questionList"]
    }
}

class OrderFeedbackQuestionDetail: Mappable {
    var question_id : String?
    var question : String?
    
    var rating : Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        question_id <- map["question_id"]
        question <- map["question"]
    }
}
