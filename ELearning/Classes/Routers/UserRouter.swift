//
//  UserRouter.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

let baseURLString = "http://35.177.230.252:3000"
var authToken: String?

enum UserRouter: URLRequestConvertible {
    
    //Variable token
    
    
    //Action
    case signIn([String: Any])
    case signUp([String : Any])
    case updatePw([String : Any])
    case updateInfo([String : Any])
    case getInfo()
    case getTest()
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signUp:
            return .post
        case .updatePw:
            return .post
        case .updateInfo:
            return .post
        case .getInfo:
            return .get
        case .getTest:
            return .get
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .signIn:
            return "/signin"
        case .signUp:
            return "/signup"
        case .updatePw:
            return "/change-password"
        case . updateInfo:
            return "/update-information"
        case .getInfo:
            return "/user-info"
        case .getTest:
            return "/get-test"
        }
    }
    
    //Request
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: baseURLString)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = authToken {
            urlRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        switch self {
        case .signIn(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .signUp(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .updatePw(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateInfo(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .getInfo():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .getTest():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        }
        
    }
}

