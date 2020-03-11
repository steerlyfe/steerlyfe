//
//  PostsModel.swift
//  Steerlyfe
//
//  Created by Nap Works on 20/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import ObjectMapper

class AllPostsResponse: Mappable {
    var status : String?
    var message : String?
    var perPageItems : Int?
    var postList : [PostDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        perPageItems <- map["perPageItems"]
        postList <- map["postList"]
    }
}


class PostDetail: Mappable {
    var postId : String?
    var postPublicId : String?
    var title : String?
    var storeName : String?
    var storeLogo : String?
    var views : Int?
    var createdTime : Double?
    var currentStatus : String?
    var postImages : [String]?
    var postSaved : Bool?
    var postImage : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        postId <- map["postId"]
        postPublicId <- map["postPublicId"]
        title <- map["title"]
        storeName <- map["storeName"]
        storeLogo <- map["storeLogo"]
        views <- map["views"]
        createdTime <- map["createdTime"]
        currentStatus <- map["currentStatus"]
        postImages <- map["postImages"]
        postSaved <- map["postSaved"]
        postImage <- map["postImage"]
    }
}
