//
//  CountryModel.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper

class CountryDetail: Mappable {
    var countryId : String?
    var countryName : String?
    var shortCode : String?
    var longCode : String?
    var callingCode : String?
    var timeZone : String?
    
    required init?(map: Map){
        
    }
    
    init(countryId : String?, countryName : String?, shortCode : String?, longCode : String?, callingCode : String?, timeZone : String?) {
        self.countryId = countryId
        self.countryName = countryName
        self.shortCode = shortCode
        self.longCode = longCode
        self.callingCode = callingCode
        self.timeZone = timeZone        
    }
    
    func mapping(map: Map) {
        countryId <- map["countryId"]
        countryName <- map["countryName"]
        shortCode <- map["shortCode"]
        longCode <- map["longCode"]
        callingCode <- map["callingCode"]
        timeZone <- map["timeZone"]
        
    }
}
