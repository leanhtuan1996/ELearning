//
//  NoticeServices.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class NoticeServices: NSObject {
    static let shared = NoticeServices()
    
    /*
     * FOR ALL USERS
     */
    
    func getSeenNotices(completionHandler: @escaping (_ notice: [NoticeObject]?, _ error: String?) -> Void) {
        Alamofire.request(UserRouter.getSeenNotices())
        .validate()
        .response { (res) in
            if let error = res.error {
                return completionHandler(nil, Helpers.handleError(res.response, error: error as NSError))
            }
            
            guard let data = res.data  else {
                return completionHandler(nil, "Invalid data format")
            }
            
            guard let notices = [NoticeObject].from(data: data) else {
                return completionHandler(nil, "Cast to notice ojbect have been failed")
            }
            
            return completionHandler(notices, nil)
        }
    }
    
    func getUnSeenNotices(completionHandler: @escaping (_ notice: [NoticeObject]?, _ error: String?) -> Void) {
        Alamofire.request(UserRouter.getUnSeenNotices())
            .validate()
            .response { (res) in
                if let error = res.error {
                    return completionHandler(nil, Helpers.handleError(res.response, error: error as NSError))
                }
                
                guard let data = res.data  else {
                    return completionHandler(nil, "Invalid data format")
                }
                
                guard let notices = [NoticeObject].from(data: data) else {
                    return completionHandler(nil, "Cast to notice ojbect have been failed")
                }
                
                return completionHandler(notices, nil)
        }
    }
    
    func getNotice(withIdStudent idStudent: String, withIdTest idTest: String, completionHandler: @escaping (_ notice: TestObject?, _ error: String?) -> Void) {
        
        let parameters: [String: Any] = [
            "studentId" : idStudent,
            "testId" : idTest
        ]
        
        Alamofire.request(UserRouter.getNotice(parameters))
        .validate()
        .response { (res) in
            if let error = res.error {
                return completionHandler(nil, Helpers.handleError(res.response, error: error as NSError))
            }
            
            guard let data = res.data, let json = data.toDictionary() else {
                return completionHandler(nil, "Invalid data format")
            }
            
            if let errors = json["errors"] as? JSON {
                if let message = errors["message"] as? String {
                    return completionHandler(nil, message)
                } else {
                    return completionHandler(nil, "Get notice error")
                }
            }
            
            guard let test = TestObject(json: json) else {
                return completionHandler(nil, "Cast to test json have been failed")
            }
            
            return completionHandler(test, nil)
        }
        
        
    }
    
    /*
     *  FOR ONLY TEACHER
     */
    
}
