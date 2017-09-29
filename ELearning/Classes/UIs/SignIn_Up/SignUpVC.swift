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
        
        let arrayTextFields: [UITextField] = [txtEmail, txtPassword, txtRetypePassword, txtFullName, txtDob]
        let arrayButtons: [UIButton] = [btnSignIn, btnSignUp]
        
        setUpUIs(uiTextFields: arrayTextFields, uiButtons: arrayButtons)

        //Email textfield
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtEmail.tag = 1
        txtEmail.keyboardType = .emailAddress
        txtEmail.becomeFirstResponder()
        
        //Password textfield
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtPassword.tag = 2
        txtPassword.isSecureTextEntry = true

        
        //RetypePassword textfield
       
        txtRetypePassword.attributedPlaceholder =
            NSAttributedString(string: "Retype Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtRetypePassword.tag = 3
        txtRetypePassword.isSecureTextEntry = true

        
        //FullName textfield
       
        txtFullName.attributedPlaceholder =
            NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtFullName.tag = 4

        
        //Dob textfield
        txtDob.attributedPlaceholder =
            NSAttributedString(string: "Day of Birth (MM/dd/yyyy)", attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtDob.tag = 5
        txtDob.returnKeyType = .done
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
            signUp()
            return true
        }
        return false
    }
    
    func signUp() {
        if !(txtEmail.hasText && txtPassword.hasText && txtRetypePassword.hasText && txtDob.hasText && txtFullName.hasText) {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text, let retypePassword = txtRetypePassword.text, let dob = txtDob.text, let fullname = txtFullName.text else {
            self.showAlert("Fields are required", title: "Please fill all fields are required!", buttons: nil)
            return
        }
        
        if password != retypePassword {
            self.showAlert("Fields are required", title: "Retype password not match", buttons: nil)
            return
        }
        
        if !dob.isValidDate() {
            self.showAlert("Day of birth invalid format", title: "Invalid format", buttons: nil)
            return
        }
        
        activityIndicatorView.showLoadingDialog(self)
        let userObject = UserObject()
        userObject.email = email
        userObject.password = password
        userObject.dob = dob
        userObject.fullname = fullname
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
