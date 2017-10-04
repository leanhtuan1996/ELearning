//
//  TeacherRouter.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire

enum TeacherRouter: URLRequestConvertible {
    
    //Action
    case getMyTest()
    case newTest([String : Any])
    case getStudentInfo([String: Any])
    
    //Variable Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMyTest:
            return .get
        case .newTest:
            return .post
        case .getStudentInfo:
            return .post
        }
    }
    
    //Variable Path
    var path: String {
        switch self {
        case .getMyTest:
            return "/teacher/get-student-info"
        case .newTest:
            return "/teacher/new-test"
        case .getStudentInfo:
            return "/teacher/get-student-info"
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
        case .getMyTest():
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: [:])
        case .newTest(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .getStudentInfo(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
}

