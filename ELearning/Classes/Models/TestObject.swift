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
    var answers: [AnswerObject]?
    
    override init() { }
    
    required init?(json: JSON) {
        guard let idTeacher: String = "teacherId" <~~ json else {
            return nil
        }
        
        if let id: String = "_id" <~~ json {
            self.id = id
        }
        
        //for loadTest() & getNotice function in TestServices
        if let id: String = "testId" <~~ json {
            self.id = id
        }
        
        self.name = "name" <~~ json
        
        let teacher = UserObject()
        teacher.id = idTeacher
        
        self.byTeacher = teacher
        
        if let questions: [JSON] = "contents" <~~ json {
            self.questions = [QuestionObject].from(jsonArray: questions)
        }
 
        if let json: JSON = "result" <~~ json {
            if let answers = json["answers"] as? [JSON] {
                self.answers = [AnswerObject].from(jsonArray: answers)
            }
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
