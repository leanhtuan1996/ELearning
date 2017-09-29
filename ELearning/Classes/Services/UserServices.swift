//
//  UserServices.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

class UserServices: NSObject {
    static let shared = UserServices()
    
    func signIn(with user: UserObject, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> ()) {
        
        let parameters = [
            "email" : user.email,
            "password" : user.password
        ]
        
        Alamofire.request(UserRouter.signIn(parameters)).validate().response { (res) in
            //Error handle
            if let err = res.error {
                return completionHandler(nil, Helpers.handleError(res.response, error: err as NSError))
            }
            
            //Data handle
            guard let data = res.data else {
                return completionHandler(nil, "Invalid data format")
            }
            
            //try parse data to json
            if let json = data.toDictionary() {
                //handle json data
                //                guard let errs = json["errors"] as? [String], let token = json["token"] as? [String] else {
                //                    return completionHandler(nil, "Invalid data format")
                //                }
                
                if let error = json["errors"] as? [String] {
                    if error.count > 0 {
                        return completionHandler(nil, error[0])
                    }
                }
                
                guard let token = json["token"] as? String else {
                    return completionHandler(nil, "Sign in incompleted with no token received")
                }
                
                //Check cast "userinfo" to [String : String]
                guard let userInfoObject = json["userInfo"] else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //login successfully
                if let userInfo = Helpers.convertObjectToJson(object: userInfoObject) {
                    print(userInfo)
                    
                    guard let user = UserObject(json: userInfo) else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    user.token = token
                    return completionHandler(user, nil)
                    //                    if token.count > 0 {
                    //                        user.token = token[0]
                    //                        return completionHandler(user, nil)
                    //                    } else {
                    //                        return completionHandler(nil, "Received with no token")
                    //
                    //                    }
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
                
            } else {
                return completionHandler(nil, "Invalid data format")
            }
        }
    }
    
    // MARK: - SIGN UP
    func signUp(with user: UserObject, completionHandler: @escaping (_ user: UserObject?, _ error: String?) -> ()){
        let parameters: [String: Any] = [
            "email" : user.email,
            "password" : user.password,
            "birthdate" : user.dob,
            "fullname" : user.fullname,
            "role" : user.role?.rawValue ?? "student"
        ]
        
        Alamofire.request(UserRouter.signUp(parameters))
            .validate()
            .response { (res) in
                
                if let err = res.error {
                    return completionHandler(nil, Helpers.handleError(res.response, error: err as NSError))
                    
                }
                
                guard let data = res.data else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //parse data to json
                if let json = data.toDictionary() {
                    
                    //handle json data
                    if let error = json["errors"] as? [String] {
                        if error.count > 0 {
                            return completionHandler(nil, error[0])
                        }
                    }
                    
                    
                    guard let token = json["token"] as? String else {
                        return completionHandler(nil, "Sign up incompleted with no token received")
                    }
                    
                    guard let userInfoObject = json["userInfo"] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    //sign up successfully
                    if let userInfo = Helpers.convertObjectToJson(object: userInfoObject) {
                        //print(userInfo)
                        
                        guard let user = UserObject(json: userInfo) else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        
                        user.token = token
                        return completionHandler(user, nil)
                        
                    } else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
        }
    }
    
    // MARK: - UPDATE PASSWORD
    func updatePw(_ oldPassword: String, newPassword: String, confirmPw: String, completionHandler: @escaping (_ error: String?) -> ()) {
        
        let parameters: [String : String] = [
            "currentPassword" : oldPassword,
            "newPassword" : newPassword,
            "confirmPassword" : confirmPw
        ]
        Alamofire.request(UserRouter.updatePw(parameters))
            .validate()
            .response { (res) in
                if let err = res.error {
                    return completionHandler(Helpers.handleError(res.response, error: err as NSError))
                    
                }
                
                guard let data = res.data else {
                    return completionHandler("Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    
                    guard let errs = json["errors"] as? [String] else {
                        return completionHandler("Invalid data format")
                        
                    }
                    //update password not successfully
                    if errs.count > 0 {
                        return completionHandler(errs[0])
                    }
                    return completionHandler(nil)
                    
                } else {
                    return completionHandler("Invalid data format")
                }
        }
    }
    
    // MARK: - UPDATE INFORMATIONS
    func updateInfo(_ user: UserObject, completionHandler: @escaping (_ error: String?) -> ()) {
        
        let parameters = [
            "birthday" : user.dob,
            "fullname" : user.fullname
        ]
        
        Alamofire.request(UserRouter.updateInfo(parameters))
            .validate()
            .response { (res) in
                //check errors
                if let err = res.error {
                    return completionHandler(Helpers.handleError(res.response, error: err as NSError))
                }
                
                guard let data = res.data else {
                    return completionHandler("Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    
                    if let errs = json["errors"] as? [String] {
                        if errs.count > 0 {
                            return completionHandler("Invalid data format")
                        }
                    }
                    return completionHandler(nil)
                    
                } else {
                    return completionHandler("Invalid data format")
                }
        }
    }
    
    // MARK: - GET INFORMATIONS
    func getInformations(_ completionHandler: @escaping(_ data: UserObject?, _ error: String?) -> ()) {
        
        Alamofire.request(UserRouter.getInfo())
            .validate()
            .response { (res) in
                //check errors
                if let err = res.error {
                    return completionHandler(nil, Helpers.handleError(res.response, error: err as NSError))
                }
                
                guard let data = res.data else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                //try parse data to json
                if let json = data.toDictionary() {
                    //print(json)
                    //check format
                    if let errs = json["errors"] as? [String] {
                        //print(errs)
                        if errs.count > 0 {
                            return completionHandler(nil, errs[0])
                        }
                    }
                    
                    guard let customerInfoObject = json["customerInfo"] else {
                        return completionHandler(nil, "Invalid data format")
                    }
                    
                    //sign up successfully
                    if let userInfo = Helpers.convertObjectToJson(object: customerInfoObject) {
                        
                        guard let userInfo = UserObject(json: userInfo) else {
                            return completionHandler(nil, "Invalid data format")
                        }
                        
                        return completionHandler(userInfo, nil)
                    } else {
                        return completionHandler(nil, "Invalid data format")
                    }
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
        }
    }
    
}
