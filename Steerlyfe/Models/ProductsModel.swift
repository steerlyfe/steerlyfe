//
//  ProductsModel.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper

class HomeProductsResponse: Mappable {
    var status : String?
    var message : String?
    var homeMessage : String?
    var trendingProducts : [ProductDetail] = []
    var suggestedProducts : [ProductDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        homeMessage <- map["homeMessage"]
        trendingProducts <- map["trendingProducts"]
        suggestedProducts <- map["suggestedProducts"]
    }
}

class CategoryProductsResponse: Mappable {
    var status : String?
    var message : String?
    var perPageItems : Int = 0
    var totalProducts : Int = 0
    var productList : [ProductDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        perPageItems <- map["perPageItems"]
        totalProducts <- map["totalProducts"]
        productList <- map["productList"]
    }
}

class ProductDetailResponse: Mappable {
    var status : String?
    var message : String?
    var productDetail : ProductDetail?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        productDetail <- map["productDetail"]
    }
}

class ProductDetail: Mappable {
    var product_id : String?
    var product_name : String?
    var store_id : String?
    var store_name : String?
    var description : String?
    var actual_price : Double?
    var sale_price : Double?
    var image_url : String?
    var quantity : Int = 0
    
    var product_public_id : String?
    var rating : Double?
    var rating_count : Int?
    var product_categories : [CategoryDetail] = []
    var product_info : [ProductInfo] = []
    var additional_features : [AdditionalFeatures] = []
    var product_availability : [ProductAvailability] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        product_id <- map["product_id"]
        product_name <- map["product_name"]
        store_id <- map["store_id"]
        store_name <- map["store_name"]
        description <- map["description"]
        actual_price <- map["actual_price"]
        sale_price <- map["sale_price"]
        image_url <- map["image_url"]
        quantity <- map["quantity"]
        
        product_public_id <- map["product_public_id"]
        rating <- map["rating"]
        rating_count <- map["rating_count"]
        product_categories <- map["product_categories"]
        product_info <- map["product_info"]
        additional_features <- map["additional_features"]
        product_availability <- map["product_availability"]
        
    }
    
    init(product_id : String?, product_name : String?, store_id : String?, description : String?, actual_price : Double?, sale_price : Double?, image_url : String?, quantity : Int) {
        self.product_id = product_id
        self.product_name = product_name
        self.store_id = store_id
        self.description = description
        self.actual_price = actual_price
        self.sale_price = sale_price
        self.image_url = image_url
        self.quantity = quantity
    }
}

class ProductInfo: Mappable {
    var type : String?
    var value : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        value <- map["value"]
    }
    
    init(type : String, value : String) {
        self.type = type
        self.value = value        
    }
}

class ProductAvailability: Mappable {
    var type : String?
    var available : Bool?
    var price : Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        available <- map["available"]
        price <- map["price"]
    }
}

class AdditionalFeatures: Mappable {
    var value : String?
    var price : Double?
    var unitType : String?
    var sellers : [SellerDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        price <- map["price"]
        unitType <- map["unitType"]
        sellers <- map["sellers"]
    }
}

class SellerDetail: Mappable {
    var sub_store_id : String?
    var store_id : String?
    var name : String?
    var address : String?
    var rating : Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        sub_store_id <- map["sub_store_id"]
        store_id <- map["store_id"]
        name <- map["name"]
        address <- map["address"]
        rating <- map["rating"]
    }
}

class CartProductDetail {
    var cart_product_id : Int?
    var product_id : String?
    var product_name : String?
    var store_id : String?
    var store_name : String?
    var description : String?
    var actual_price : Double?
    var sale_price : Double?
    var image_url : String?
    var quantity : Int?
    var additional_feature : String?
    var additional_feature_price : Double?
    var available_type : String?
    var sub_store_id : String?
    var additional_charges : Double?
    var sub_store_address : String?
    
    init(cart_product_id : Int, product_id : String, product_name : String, store_id : String, store_name : String?, description : String, actual_price : Double, sale_price : Double, image_url : String, quantity : Int, additional_feature : String, available_type : String, sub_store_id : String, additional_charges : Double, additional_feature_price : Double?, sub_store_address : String?) {
        self.cart_product_id = cart_product_id
        self.product_id = product_id
        self.product_name = product_name
        self.store_id = store_id
        self.store_name = store_name
        self.description = description
        self.actual_price = actual_price
        self.sale_price = sale_price
        self.image_url = image_url
        self.quantity = quantity
        self.additional_feature = additional_feature
        self.available_type = available_type
        self.sub_store_id = sub_store_id
        self.additional_charges = additional_charges
        self.additional_feature_price = additional_feature_price
        self.sub_store_address = sub_store_address
    }
}

class CommonSearchResponse: Mappable {
    var status : String?
    var message : String?
    var perPageItems : Int?
    var productList : [ProductDetail]?
    var storeList : [StoreDetail]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        perPageItems <- map["perPageItems"]
        productList <- map["productList"]
        storeList <- map["storeList"]
    }
}
