//
//  StoreModel.swift
//  Steerlyfe
//
//  Created by nap on 03/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper

class NearbyStoresResponse: Mappable {
    var status : String?
    var message : String?
    var nearbyStores : [StoreDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        nearbyStores <- map["nearbyStores"]
    }
}

class StoreDetailResponse: Mappable {
    var status : String?
    var message : String?
    var storeDetail : StoreDetail?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        storeDetail <- map["storeDetail"]
    }
}

class StoreDetail: Mappable {
    var subStoreId : String?
    var storeId : String?
    var storeName : String?
    var address : String?
    var storeLogo : String?
    var storeRating : Double?
    var lat : Double?
    var lng : Double?
    var distance : Double?
    
    var description : String?
    var bannerUrl : String?
    var phoneNumber : String?
    var email : String?
    var openingTime : String?
    var closingTime : String?
    var ratingCount : Int?
    var userRated : Bool?
    var reviews : [ReviewDetail] = []
    var postsList : [PostDetail] = []
    
    var selected : Bool = false
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        subStoreId <- map["subStoreId"]
        storeId <- map["storeId"]
        storeName <- map["storeName"]
        address <- map["address"]
        storeLogo <- map["storeLogo"]
        storeRating <- map["storeRating"]
        lat <- map["lat"]
        lng <- map["lng"]
        distance <- map["distance"]
        
        description <- map["description"]
        bannerUrl <- map["bannerUrl"]
        phoneNumber <- map["phoneNumber"]
        email <- map["email"]
        openingTime <- map["openingTime"]
        closingTime <- map["closingTime"]
        ratingCount <- map["ratingCount"]
        userRated <- map["userRated"]
        reviews <- map["reviews"]
        postsList <- map["postsList"]
    }
}

class ReviewDetail: Mappable {
    var review_id : String?
    var user_id : String?
    var full_name : String?
    var image_url : String?
    var rating : Double?
    var rating_time : Double?
    var description : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        review_id <- map["review_id"]
        user_id <- map["user_id"]
        full_name <- map["full_name"]
        image_url <- map["image_url"]
        rating <- map["rating"]
        rating_time <- map["rating_time"]
        description <- map["description"]
    }
}
