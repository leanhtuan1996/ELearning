//
//  SignInVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let appDelegate = UIApplication.shared.delegate
    let activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Email textfield
        txtEmail.layer.borderColor = UIColor.white.cgColor
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.cornerRadius = 5
        txtEmail.backgroundColor = UIColor.clear
        txtEmail.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtEmail.textColor = UIColor.white
        txtEmail.tag = 1
        txtEmail.becomeFirstResponder()
        txtEmail.keyboardType = .emailAddress
        
        //Password textField
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 5
        txtPassword.backgroundColor = UIColor.clear
        txtPassword.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPassword.textColor = UIColor.white
        txtPassword.tag = 2
        txtPassword.returnKeyType = .go
        
        //Sign In button
        btnSignIn.layer.cornerRadius = 10
        
        //Sign Up button
        btnSignUp.layer.cornerRadius = 10
        
    }

    // MARK: - DELEGATE UITEXTFIELDS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signIn()
            return true
        }
        return false
    }
    
    // MARK: - FUNTIONS
    func signIn() {
        
        if !(txtEmail.hasText && txtPassword.hasText) {
            self.showAlert("Please fill all fields are required!", title: "Fields are required", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            return
        }
        
        if !Helpers.validateEmail(email) {
            self.showAlert("Email invalid format", title: "Fields are required", buttons: nil)
            return
        }
        
        let userObject = UserObject()
        userObject.password = password
        userObject.email = email
        
        activityIndicatorView.showLoadingDialog(self)
        UserServices.shared.signIn(with: userObject) { (user, error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Sign In Error", buttons: nil)
                return
            }
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                switch user?.role ?? userRole.student {
                case .student:
                    appDelegate.showMainViewStudent()
                case .teacher:
                    appDelegate.showMainViewAdmin()
                }
            }
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func btnSignUp(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showSignUpView()
        }
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        signIn()
    }

}
