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
    var idTeacher: String?
    var content: [String]?
    
    override init() { }
    
    required init?(json: JSON) {
        guard let id: String = "_id" <~~ json, let idTeacher: String = "teacherId" <~~ json else {
            return nil
        }
        
        self.id = id
        self.name = "name" <~~ json
        self.idTeacher = idTeacher
        self.content = "content" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "name" ~~> self.name,
            "idTeacher" ~~> self.idTeacher,
            "content" ~~> self.content
            ])
    }
    
}
