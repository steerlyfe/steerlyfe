//
//  LoginSignupModel.swift
//  Steerlyfe
//
//  Created by nap on 27/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper

class LoginResponse: Mappable {
    var status : String?
    var message : String?
    var userDetail : UserDetail?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        userDetail <- map["userDetail"]
    }
}

class UserDetail: Mappable {
    var userId : String?
    var accountId : String?
    var fullName : String?
    var phoneNumber : String?
    var email : String?
    var authToken : String?
    var sessionToken : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        accountId <- map["accountId"]
        fullName <- map["fullName"]
        phoneNumber <- map["phoneNumber"]
        email <- map["email"]
        authToken <- map["authToken"]
        sessionToken <- map["sessionToken"]
    }
}
