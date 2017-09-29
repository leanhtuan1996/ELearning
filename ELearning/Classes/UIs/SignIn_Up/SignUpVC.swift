//
//  SignUpVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetypePassword: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtDob: UITextField!
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
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtEmail.textColor = UIColor.white
        txtEmail.tag = 1
        txtEmail.keyboardType = .emailAddress
        txtEmail.becomeFirstResponder()
        
        //Password textfield
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 5
        txtPassword.backgroundColor = UIColor.clear
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPassword.textColor = UIColor.white
        txtPassword.tag = 2
        txtPassword.isSecureTextEntry = true

        
        //RetypePassword textfield
        txtRetypePassword.layer.borderColor = UIColor.white.cgColor
        txtRetypePassword.layer.borderWidth = 1
        txtRetypePassword.layer.cornerRadius = 5
        txtRetypePassword.backgroundColor = UIColor.clear
        txtRetypePassword.attributedPlaceholder =
            NSAttributedString(string: "Retype Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtRetypePassword.textColor = UIColor.white
        txtRetypePassword.tag = 3
        txtRetypePassword.isSecureTextEntry = true

        
        //FullName textfield
        txtFullName.layer.borderColor = UIColor.white.cgColor
        txtFullName.layer.borderWidth = 1
        txtFullName.layer.cornerRadius = 5
        txtFullName.backgroundColor = UIColor.clear
        txtFullName.attributedPlaceholder =
            NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtFullName.textColor = UIColor.white
        txtFullName.tag = 4

        
        //Dob textfield
        txtDob.layer.borderColor = UIColor.white.cgColor
        txtDob.layer.borderWidth = 1
        txtDob.layer.cornerRadius = 5
        txtDob.backgroundColor = UIColor.clear
        txtDob.attributedPlaceholder =
            NSAttributedString(string: "Day of Birth", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtDob.textColor = UIColor.white
        txtDob.tag = 5
        
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
            signUp()
            return true
        }
        return false
    }
    
    func signUp() {
        if !(txtEmail.hasText && txtPassword.hasText) {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text, let retypePassword = txtRetypePassword.text else {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        if password != retypePassword {
            self.showAlert("Fields are required", title: "Retype password not match", buttons: nil)
            return
        }
        
        activityIndicatorView.showLoadingDialog(self)
        let userObject = UserObject()
        userObject.email = email
        userObject.password = password
        UserServices.shared.signUp(with: userObject) { (user, error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Sign In Error", buttons: nil)
                return
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
               appDelegate.showMainViewStudent()
            }
            
        }
    }
    
    // MARK: - ACTION
    
    @IBAction func btnSignUp(_ sender: Any) {
        signUp()
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showSignInView()
        }
    }

}
