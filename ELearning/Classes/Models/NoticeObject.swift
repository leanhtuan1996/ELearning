//
//  NoticeObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

class NoticeObject: NSObject, Decodable {
    var id: String?
    var test: TestObject?
    var student: UserObject?
    var isSeen: Bool?
    
    override init() { }
    
    required init?(json: JSON) {
        self.id = "_id" <~~ json
        if let testId: String = "testId" <~~ json, let name: String = "name" <~~ json {
            let test = TestObject()
            test.id = testId
            test.name = name
            self.test = test
        }
        
        if let studentId: String = "studentId" <~~ json {
            let student = UserObject()
            student.id = studentId
            self.student = student
        }
        
        self.isSeen = "seen" <~~ json
        
    }
}
