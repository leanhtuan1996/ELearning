//
//  UpdatePasswordVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class UpdatePasswordVC: UIViewController {
    
    let loading = UIActivityIndicatorView()
    
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSave(_ sender: Any) {
        
        if !(txtCurrentPassword.hasText && txtConfirmNewPassword.hasText && txtNewPassword.hasText) {
            self.showAlert("Fields are required", title: "Fields have be not empty", buttons: nil)
            return
        }
        
        //check nil
        guard let oldPassword = txtCurrentPassword.text, let newPassword = txtNewPassword.text, let confirmPassword = txtConfirmNewPassword.text else {
            return
        }
        
        //check match between newPw & confirmPw
        if newPassword != confirmPassword {
            self.showAlert("Retype new password not match", title: "Error", buttons: nil)
            return
        }
        loading.showLoadingDialog(self)
        UserServices.shared.updatePw(oldPassword, newPassword: newPassword, confirmPw: confirmPassword) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Update password error", buttons: nil)
                return
            }
            
            let action = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.showAlert("Password has been updated successfully", title: "Thông báo", buttons: [action])
        }
    }
}
