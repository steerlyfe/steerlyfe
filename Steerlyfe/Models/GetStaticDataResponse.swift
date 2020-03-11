//
//  GetStaticDataResponse.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import ObjectMapper

class GetStaticDataResponse: Mappable {
    var status : String = ""
    var message : String = ""
    var countriesList : [CountryDetail] = []
    var categoriesList : [CategoryDetail] = []
    var quizQuestions : [QuizQuestionDetail] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        countriesList <- map["countriesList"]
        categoriesList <- map["categoriesList"]
        quizQuestions <- map["quizQuestions"]
    }
}
