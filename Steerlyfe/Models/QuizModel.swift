//
//  QuizModel.swift
//  Steerlyfe
//
//  Created by nap on 01/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import ObjectMapper

class QuizQuestionDetail: Mappable {
    var question_id : String?
    var question_public_id : String?
    var question : String?
    var options_list : [String] = []
    var selected_options_index : [Int] = []
    
    required init?(map: Map){
        
    }
    
    init(question_id : String?, question_public_id : String?, question : String?, options_list : [String]) {
        self.question_id = question_id
        self.question_public_id = question_public_id
        self.question = question
        self.options_list = options_list
    }
    
    func mapping(map: Map) {
        question_id <- map["question_id"]
        question_public_id <- map["question_public_id"]
        question <- map["question"]
        options_list <- map["options_list"]
    }
}
