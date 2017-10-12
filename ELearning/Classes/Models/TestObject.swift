//
//  TestObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class TestObject: NSObject, Glossy {
    var id: String?
    var name: String?
    var byTeacher: UserObject?
    var questions: [QuestionObject]?
    //var answers: [AnswerObject]?
    var results: [ResultObject]?
    
    override init() { }
    
    required init?(json: JSON) {
        
        if let id: String = "_id" <~~ json {
            self.id = id
        }
        
        //for loadTest() & getNotice function in TestServices
        if let id: String = "testId" <~~ json {
            self.id = id
        }
        
        self.name = "name" <~~ json
        
        let teacher = UserObject()
        teacher.id = "teacherId" <~~ json
        
        self.byTeacher = teacher
        
        if let questions: [JSON] = "contents" <~~ json {
            self.questions = [QuestionObject].from(jsonArray: questions)
        }
 
        //For load-test
        if let json: JSON = "result" <~~ json {
//            if let answers = json["answers"] as? [JSON] {
//                self.answers = [AnswerObject].from(jsonArray: answers)
//            }
            
            var arrayResult: [ResultObject] = []
            
            if let result = ResultObject(json: json) {
                arrayResult.append(result)
            }
            
            self.results = arrayResult
            
        }
        
        //for get-my-tests
        if let json: [JSON] = "results" <~~ json {
            self.results = [ResultObject].from(jsonArray: json)
        }
        
        
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "name" ~~> self.name,
            "idTeacher" ~~> self.byTeacher?.id,
            "contents" ~~> self.questions
            ])
    }
    
}
