//
//  QuestionObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/7/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class QuestionObject: NSObject, Glossy {
    var id: String?
    var question: String?
    
    override init() { }
    
    required init?(json: JSON) {
        self.id = "_id" <~~ json
        self.question = "question" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "_id" ~~> self.id,
            "question" ~~> self.question
            ])
    }
}
