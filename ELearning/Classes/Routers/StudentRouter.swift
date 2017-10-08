//
//  StudentRouter.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

enum StudentRouter: URLRequestConvertible {
    
    //Action
    case loadTest([String: Any])
    case answerTest([String : Any])
    case joinTest([String: Any])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .loadTest:
            return .post
        case .answerTest:
            return .post
        case .joinTest:
            return .post
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .loadTest:
            return "/student/load-test"
        case .answerTest:
            return "/student/save-answer"
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
        case .loadTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .joinTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .answerTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
}

