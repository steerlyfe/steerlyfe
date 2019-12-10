//
//  ProductsModel.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper
import RealmSwift

class HomeProductsResponse: Mappable {
    var status : String?
    var message : String?
    var trendingProducts : [ProductDetail] = []
    var suggestedProducts : [ProductDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        trendingProducts <- map["trendingProducts"]
        suggestedProducts <- map["suggestedProducts"]
    }
}

class CategoryProductsResponse: Mappable {
    var status : String?
    var message : String?
    var perPageItems : Int = 0
    var productList : [ProductDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        perPageItems <- map["perPageItems"]
        productList <- map["productList"]
    }
}

class ProductDetail: Mappable {
    var product_id : String?
    var category_id : String?
    var product_name : String?
    var store_id : String?
    var description : String?
    var actual_price : Double?
    var sale_price : Double?
    var image_url : String?
    var quantity : Int = 0
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        product_id <- map["product_id"]
        category_id <- map["category_id"]
        product_name <- map["product_name"]
        store_id <- map["store_id"]
        description <- map["description"]
        actual_price <- map["actual_price"]
        sale_price <- map["sale_price"]
        image_url <- map["image_url"]
        quantity <- map["quantity"]
    }
    
    init(product_id : String?, category_id : String?, product_name : String?, store_id : String?, description : String?, actual_price : Double?, sale_price : Double?, image_url : String?, quantity : Int) {
        self.product_id = product_id
        self.category_id = category_id
        self.product_name = product_name
        self.store_id = store_id
        self.description = description
        self.actual_price = actual_price
        self.sale_price = sale_price
        self.image_url = image_url
        self.quantity = quantity
    }
}

class DatabaseProductDetail: Object {
    @objc dynamic var product_id : String = ""
    @objc dynamic var category_id : String = ""
    @objc dynamic var product_name : String = ""
    @objc dynamic var store_id : String = ""
    @objc dynamic var product_description : String = ""
    @objc dynamic var actual_price : Double = 0.0
    @objc dynamic var sale_price : Double = 0.0
    @objc dynamic var image_url : String = ""
    @objc dynamic var quantity : Int = 0
    
    override class func primaryKey() -> String? {
        return "product_id"
    }
    
}
