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
    var callingCode : String?
    var email : String?
    var authToken : String?
    var sessionToken : String?
    var questionSubmitted : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        accountId <- map["accountId"]
        fullName <- map["fullName"]
        phoneNumber <- map["phoneNumber"]
        callingCode <- map["callingCode"]
        email <- map["email"]
        authToken <- map["authToken"]
        sessionToken <- map["sessionToken"]
        questionSubmitted <- map["questionSubmitted"]
    }
}

class StatusMessageModel: Mappable {
    var status : String?
    var message : String?
    var errorData : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        errorData <- map["errorData"]
    }
}

class SortingOptions {
    var sortingName : String?
    var sortingType : SortingType?
    var apiType : String?
    
    init(sortingName : String, sortingType : SortingType, apiType : String) {
        self.sortingName = sortingName
        self.sortingType = sortingType
        self.apiType = apiType
    }
}

