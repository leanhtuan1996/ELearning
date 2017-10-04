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
    case signIn([String: String])
    case signUp([String : Any])
    case updatePw([String : String])
    case updateInfo([String : String])
    case getInfo()
    case loadTest()
    case doTest([String : Any])
    case joinTest([String: Any])
    
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
        case .loadTest:
            return .get
        case .doTest:
            return .post
        case .joinTest:
            return .post
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
        case .loadTest:
            return "/student/load-test"
        case .doTest:
            return "/student/do-test"
        case .joinTest:
            return "/student/join-test"
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
        case .loadTest():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .joinTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .doTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
}

