//
//  CategoryModel.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper
import RealmSwift

class CategoryDetail: Mappable {
    var categoryId : String?
    var categoryName : String?
    var categoryUrl : String?
    
    required init?(map: Map){
        
    }
    
    init(categoryId : String, categoryName : String?, categoryUrl : String?) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.categoryUrl = categoryUrl        
    }
    
    func mapping(map: Map) {
        categoryId <- map["categoryId"]
        categoryName <- map["categoryName"]
        categoryUrl <- map["categoryUrl"]
    }
}

class DatabaseCategoryDetail: Object {
    @objc dynamic var categoryId : String = ""
    @objc dynamic var categoryName : String = ""
    @objc dynamic var categoryUrl : String = ""
    
    override class func primaryKey() -> String? {
        return "categoryId"
    }
    
}
