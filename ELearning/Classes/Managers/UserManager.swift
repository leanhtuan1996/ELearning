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
            UserServices.shared.getInformations(completionHandler: { (user, error) in
                if let error = error {
                    return completionHandler(nil, error)
                }
                if let user = user {
                    self.setToken(token)
                    self.setCurrentUser(with: user)
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
    
    func getCurrentUser() -> UserObject? {
        if let data = userDefaults.object(forKey: "User") as? Data {
            if let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserObject {
                self.currentUser = user
                return user
            }
            return nil
        }
        return nil
    }
    
    func setCurrentUser(with user: UserObject?) {
        if let user = user {
            //set
            addCurrentUser(with: user)
        } else {
            //delete
            deleteCurrentUser()
        }
    }
    
    func addCurrentUser(with user: UserObject) {
        //set
        let userEncode:Data = NSKeyedArchiver.archivedData(withRootObject: user)
        userDefaults.set(userEncode, forKey: "User")
        userDefaults.synchronize()
    }
    
    func deleteCurrentUser() {
        if userDefaults.object(forKey: "User") != nil {
            //remove
            userDefaults.removeObject(forKey: "User")
        }
    }
    
    
}
