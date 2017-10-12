//
//  AnswerObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class ResultObject: NSObject, Glossy {
    var id: String?
    var byStudent: UserObject?
    var status: Bool?
    var answers: [AnswerObject]?
    
    override init() {
        
    }
    
    required init?(json: JSON) {
      
        self.id = "_id" <~~ json
        
        if let studentId: String = "studentId" <~~ json {
            let userObject = UserObject()
            userObject.id = studentId
        }
        self.status = "status" <~~ json
        
        if let json: [JSON] = "answers" <~~ json {
            print(json)
            self.answers = [AnswerObject].from(jsonArray: json)
        }
        
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "_id" ~~> self.id
            ])
    }
}
