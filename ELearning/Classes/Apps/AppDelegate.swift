//
//  AppDelegate.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showMainViewStudent() {
        if let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC {
            self.window?.rootViewController = sb
        }
    }
    
    func showMainViewTeacher() {
        if let sb = UIStoryboard(name: "Teacher", bundle: nil).instantiateViewController(withIdentifier: "TeacherMainVC") as? TeacherMainVC {
            self.window?.rootViewController = sb
        }
    }
    
    func showSignInView() {
        if let sb = UIStoryboard(name: "SignInUp", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
            self.window?.rootViewController = sb
        }
    }
    
    func showSignUpView(){
        if let sb = UIStoryboard(name: "SignInUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            self.window?.rootViewController = sb
        }
    }
    
    func signIn_Up(user: UserObject) {
        UserManager.shared.currentUser = user
        
        //set token to NSUserDefault & UserNetwork
        UserManager.shared.setToken(user.token)
        
        switch user.role ?? userRole.student {
        case .teacher:
            showMainViewTeacher()
        case .student:
            showMainViewStudent()
        }
    }
    
    func signOut() {
        UserManager.shared.signOut()
        showSignInView()
    }
}

