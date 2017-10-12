//
//  AnswerObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class AnswerObject: NSObject, Glossy {
    var id: String?
    var questionId: String?
    var fileName: String?
    var score: Int?
    
    override init() {
        
    }
    
    required init?(json: JSON) {
        guard let id: String = "_id" <~~ json, let questionId: String = "questionId" <~~ json else {
            return nil
        }
        self.id = id
        self.questionId = questionId
        self.fileName = "fileName" <~~ json
        self.score = "score" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "_id" ~~> self.id
            ])
    }
}
