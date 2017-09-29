//
//  LaunchVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if UserManager.shared.isLoggedIn() {
                
                //verify token
                UserManager.shared.verifyToken({ (user, error) in
                    
                    if let error = error {
                        print(error)
                        appDelegate.showSignInView()
                        return
                    }
                    
                    guard let user = user else {
                        print("User not found")
                        appDelegate.showSignInView()
                        return
                    }
                    
                    guard let token = user.token else {
                        print("Token not found")
                        appDelegate.showSignInView()
                        return
                    }
                    
                    //set token
                    UserManager.shared.setToken(token)
                    
                    //check role
                    switch user.role ?? userRole.student {
                    case .student:
                        appDelegate.showMainViewAdmin()
                    case .teacher:
                        appDelegate.showMainViewStudent()
                    }
                    
                })
                
                //show main view
            } else {
                appDelegate.showSignInView()
            }
        }
        
    }
}

