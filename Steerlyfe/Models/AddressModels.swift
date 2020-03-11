//
//  AddressModels.swift
//  Steerlyfe
//
//  Created by Nap Works on 04/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import ObjectMapper

class AddAddressModel: Mappable {
    var status : String?
    var message : String?
    var addressId : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        addressId <- map["addressId"]
    }
}

class AddressListResponse: Mappable {
    var status : String?
    var message : String?
    var addressList : [AddressDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        addressList <- map["addressList"]
    }
}

class AddressDetail: Mappable {
    var address_id : String?
    var calling_code : String?
    var phone_number : String?
    var name : String?
    var email : String?
    var country : String?
    var pincode : String?
    var address : String?
    var locality : String?
    var city : String?
    var state : String?
    var isDefault : Bool?
    
    required init?(map: Map){
        
    }
    
    init(address_id : String, calling_code : String, phone_number : String, name : String, email : String, country : String, pincode : String, address : String, locality : String, city : String, state : String, isDefault : Bool?) {
        self.address_id = address_id
        self.calling_code = calling_code
        self.phone_number = phone_number
        self.name = name
        self.email = email
        self.country = country
        self.pincode = pincode
        self.address = address
        self.locality = locality
        self.city = city
        self.state = state
        self.isDefault = isDefault
    }
    
    func mapping(map: Map) {
        address_id <- map["address_id"]
        calling_code <- map["calling_code"]
        phone_number <- map["phone_number"]
        name <- map["name"]
        email <- map["email"]
        country <- map["country"]
        pincode <- map["pincode"]
        address <- map["address"]
        locality <- map["locality"]
        city <- map["city"]
        state <- map["state"]
        isDefault <- map["isDefault"]
        
    }
}
