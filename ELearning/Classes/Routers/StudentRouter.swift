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
    case loadTest()
    case doTest([String : Any])
    case joinTest([String: Any])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
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
        case .loadTest():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .joinTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .doTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
}

