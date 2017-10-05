//
//  TestServices.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class TestServices: NSObject {

    static let shared = TestServices()
    
    /*
     * FUNCTIONS FOR ALL USERS
     */
    
    // MARK: - GET ALL TESTS
    func getTests(completionHandler: @escaping (_ tests: [TestObject]?, _ error: String?) -> Void) {
        Alamofire.request(UserRouter.getTests())
            .validate()
            .response { (res) in
                if let error = res.error {
                    return completionHandler(nil, Helpers.handleError(res.response, error: error as NSError))
                }
                                
                guard let data = res.data else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                if let test = [TestObject].from(data: data) {
                    return completionHandler(test, nil)
                } else {
                    return completionHandler(nil, "Invalid data format")
                }
                
        }
    }
    
    /*
     * FUNCTIONS FOR STUDENTS
     */
    
    // MARK: - GET TESTS
    
    func loadTest(withId id: String, completionHandler: @escaping (_ test: TestObject?, _ error: String?) -> Void) {
        let parameter: [String: Any] = [
            "testId": id
        ]
        
        print(id)
        
        Alamofire.request(StudentRouter.loadTest(parameter))
        .validate()
        .response { (res) in
            if let error = res.error {
                return completionHandler(nil, Helpers.handleError(res.response, error: error as NSError))
            }
            
            guard let data = res.data else {
                print("1")
                return completionHandler(nil, "Invalid data format")
            }
            
            if let responeJSON = data.toDictionary() {
                //if error
                if let error = responeJSON["errors"] as? [String] {
                    if error.count > 0 {
                        return completionHandler(nil, error[0])
                    }
                }
                
                //success
                guard let testJSON = responeJSON["test"] as? JSON else {
                    print("2")
                    return completionHandler(nil, "Invalid data format")
                }
                
                if let test = TestObject(json: testJSON) {
                    return completionHandler(test, nil)
                } else {
                    print("3")
                    return completionHandler(nil, "Invalid data format")
                }
                
            } else {
                print("4")
                return completionHandler(nil, "Invalid data format")
            }
        }
    }
    
    func joinTest(withId id: String, completionHandler: @escaping (_ error: String?) -> Void ) {
        let parameters: [String: Any] = [
            "testId" : id
        ]
        
        Alamofire.request(StudentRouter.joinTest(parameters))
        .validate()
        .response { (res) in
            if let error = res.error {
                return completionHandler(Helpers.handleError(res.response, error: error as NSError))
            }
            
            guard let data = res.data, let dataJson = data.toDictionary() else {
                return completionHandler("Invalid data format")
            }
            
            if let errors = dataJson["errors"] as? [String] {
                if errors.count > 0 {
                    return completionHandler(errors[0])
                }
                return completionHandler(nil)
            } else {
                return completionHandler("Invalid data format")
            }
            
        }
    }
    
    func doTest() {
        
    }
    
    
    /*
     * FUNCTIONS FOR TEACHERS
     */
    
    func getMyTests() {
        
    }
    
    func newTest() {
        
    }
    
    func getStudentInfo() {
        
    }
}
