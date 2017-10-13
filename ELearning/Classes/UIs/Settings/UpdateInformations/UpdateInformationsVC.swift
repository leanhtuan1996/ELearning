//
//  UpdateInformationsVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class UpdateInformationsVC: UIViewController {

    let loading = UIActivityIndicatorView()
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


    @IBAction func btnSave(_ sender: Any) {
        
        //check empty
        if !(txtFullName.hasText && txtBirthday.hasText) {
            self.showAlert("Fields can not empty", title: "Fields are required", buttons: nil)
            return
        }
        
        guard let fullName = txtFullName.text, let birthDay = txtBirthday.text else {
            return
        }
        
        if !birthDay.isValidDate() {
            self.showAlert("Please enter the correct date of birth in the format: MM/dd/yyyy", title: "Birthdate not properly formatted", buttons: nil)
            return
        }
        
        let userObject = UserObject()
        userObject.fullname = fullName
        userObject.dob = birthDay
        
        loading.showLoadingDialog(self)
        UserServices.shared.updateInfo(userObject) { (error) in
            self.loading.stopAnimating()
            
            if let error = error {
                self.showAlert(error, title: "Update information failed", buttons: nil)
                return
            }
            
            //show alert
            let alert = UIAlertController(title: "Thông báo", message: "Infomations has been updated successfully", preferredStyle: .alert)
            alert.addAction(.init(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                UserManager.shared.currentUser = userObject
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
