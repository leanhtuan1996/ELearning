//
//  UserObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Gloss

enum userRole: String {
    case teacher = "teacher"
    case student = "student"
}

class UserObject: NSObject, Decodable {
    var email: String = ""
    var password: String = ""
    var fullname: String = ""
    var dob: String = ""
    var token: String?
    var role: userRole?
    
    override init() { }
    
    required init?(json: JSON) {
        guard let email: String = "email" <~~ json else {
            return nil
        }
        
        self.email = email
        self.password = "password" <~~ json ?? ""
        self.fullname = "fullname" <~~ json ?? ""
        self.dob = "dob" <~~ json ?? ""
        //self.role = userRole(rawValue: "role" <~~ json ?? "student")
        self.role = "role" <~~ json
        
    }
}
