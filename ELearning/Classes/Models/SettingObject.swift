//
//  SettingObject.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit


enum SettingType: String {
    case logout = "logout"
    case updatePw = "UpdatePw"
    case updateInfo = "UpdateInfo"
}

class SettingObject: NSObject {
    var name:String?
    var type: SettingType
    
    init(name: String, type: SettingType) {
        self.name = name
        self.type = type
    }
}

