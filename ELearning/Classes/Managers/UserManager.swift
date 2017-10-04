//
//  UserManager.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    let userDefaults = UserDefaults.standard
    var currentUser: UserObject?
    
    //check token in NSUserDefaults
    func isLoggedIn() -> Bool {
        if userDefaults.object(forKey: "token") != nil {
            return true
        }
        return false
    }
    
    //set token
    func setToken(_ token: String? = nil) {
        //if token is null => set
        //token is not nul => delete
        if token != nil {
            userDefaults.set(token, forKey: "token")
            authToken = token
        } else {
            authToken = nil
            if userDefaults.object(forKey: "token") != nil {
                userDefaults.removeObject(forKey: "token")
            }
        }
    }
    
    //Get token in NSUserDefaults
    func getToken() -> String? {
        if let token = userDefaults.object(forKey: "token") as? String {
            return token
        }
        return nil
    }
    
    func verifyToken(_ completionHandler: @escaping(_ user: UserObject?, _ error: String?) -> Void) {
        if let token = userDefaults.object(forKey: "token") as? String {
            authToken = token
            UserServices.shared.getInformations({ (user, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                if let user = user {
                   self.setToken(token)
                   return completionHandler(user, nil)
                }
            })
        } else {
            return completionHandler(nil, "Verified token failed")
        }
    }
    
    func signOut() {
        setToken()
        currentUser = nil
    }
    
}
