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

class UserObject: NSObject, NSCoding, Glossy {
    var id: String?
    var email: String?
    var password: String?
    var fullname: String?
    var dob: String?
    var token: String?
    var role: userRole?
    
    override init() { }
    
    /*
     * JSON
     */
    required init?(json: JSON) {
        guard let email: String = "email" <~~ json else {
            return nil
        }
        self.email = email
        self.id = "userId" <~~ json
        self.password = "password" <~~ json
        self.fullname = "fullname" <~~ json
        self.dob = "birthdate" <~~ json
        if let role: String = "role" <~~ json {
            self.role = userRole(rawValue: role)
        }
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "email" ~~> self.email,
            "password" ~~> self.password,
            "fullname" ~~> self.fullname,
            "birthday" ~~> self.dob,
            "role" ~~> self.role?.rawValue
            ])
    }
    
    /*
     * NSCODER
     */
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        fullname = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        role = userRole(rawValue: (aDecoder.decodeObject(forKey: "role") as? String ?? "student"))
        dob = aDecoder.decodeObject(forKey: "dob") as? String ?? ""
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        if let id = id {
            aCoder.encode(id, forKey: "id")
        }
        
        if let fullname = fullname {
            aCoder.encode(fullname, forKey: "fullname")
        }
        
        if let role = role {
            aCoder.encode(role.rawValue, forKey: "role")
        }
        
        if let dob = dob {
            aCoder.encode(dob, forKey: "dob")
        }
    }

}
