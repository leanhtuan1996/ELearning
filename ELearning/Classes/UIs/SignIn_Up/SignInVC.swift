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
        
        setUpUIs(uiTextFields: [txtEmail, txtPassword], uiButtons: [btnSignIn, btnSignUp])

        //Email textfield
        txtEmail.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtEmail.tag = 1
        txtEmail.becomeFirstResponder()
        txtEmail.keyboardType = .emailAddress
        
        //Password textField
        txtPassword.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPassword.tag = 2
        txtPassword.returnKeyType = .go
        
    }
    
    func setUpUIs(uiTextFields: [UITextField]?, uiButtons: [UIButton]?) {
        if let arrayTextFields = uiTextFields {
            for textFields in arrayTextFields {
                textFields.layer.borderColor = UIColor.white.cgColor
                textFields.layer.borderWidth = 1
                textFields.layer.cornerRadius = 5
                textFields.backgroundColor = UIColor.clear
                textFields.textColor = UIColor.white
            }
        }
        
        if let arrayUIButton = uiButtons {
            for button in arrayUIButton {
                button.layer.cornerRadius = 10
            }
        }
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
            
            if let user = user {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.signIn_Up(user: user)
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
