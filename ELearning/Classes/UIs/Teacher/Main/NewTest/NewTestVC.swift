//
//  NewTestVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class NewTestVC: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    var arrayTextFields: [UITextField] = []
    
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var txtName: UITextField!
    
    let loading = UIActivityIndicatorView()
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpView() {
        self.scrollView = UIScrollView()
        self.contentView = UIView()
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        
        //scrollView
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.lblQuestions.bottomAnchor, constant: 20).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.btnDone.topAnchor).isActive = true
        
        
        //content view
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
    }
    
    
    
    func addTextField() {
        
        if arrayTextFields.count == 0 {
            //textfield
            let txtQuestionName = UITextField()
            txtQuestionName.placeholder = "Name of Question"
            txtQuestionName.font = UIFont.systemFont(ofSize: 15)
            txtQuestionName.borderStyle = UITextBorderStyle.roundedRect
            txtQuestionName.autocorrectionType = UITextAutocorrectionType.no
            txtQuestionName.keyboardType = UIKeyboardType.default
            txtQuestionName.returnKeyType = UIReturnKeyType.done
            txtQuestionName.clearButtonMode = UITextFieldViewMode.whileEditing;
            txtQuestionName.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            txtQuestionName.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(txtQuestionName)
            
            txtQuestionName.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
            txtQuestionName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
            txtQuestionName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
            txtQuestionName.heightAnchor.constraint(equalToConstant: 45).isActive = true
            //txtQuestionName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 50).isActive = true
            self.arrayTextFields.append(txtQuestionName)
            print(self.contentView.frame.height)
            return
            
        }
        
        
        let preTxt = arrayTextFields[arrayTextFields.count - 1]
        
        //textfield
        let txtQuestionName = UITextField()
        txtQuestionName.placeholder = "Name of Question"
        txtQuestionName.isUserInteractionEnabled = true
        txtQuestionName.font = UIFont.systemFont(ofSize: 15)
        txtQuestionName.borderStyle = UITextBorderStyle.roundedRect
        txtQuestionName.autocorrectionType = UITextAutocorrectionType.no
        txtQuestionName.keyboardType = UIKeyboardType.default
        txtQuestionName.returnKeyType = UIReturnKeyType.done
        txtQuestionName.clearButtonMode = UITextFieldViewMode.whileEditing;
        txtQuestionName.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txtQuestionName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(txtQuestionName)
        txtQuestionName.topAnchor.constraint(equalTo: preTxt.topAnchor, constant: 60).isActive = true
        txtQuestionName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        txtQuestionName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        txtQuestionName.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.arrayTextFields.append(txtQuestionName)
        //print(self.contentView.frame.height)
        
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        let test = TestObject()
        var questions: [QuestionObject] = []
        guard let name = txtName.text, txtName.hasText == true else {
            self.showAlert("Name can not empty", title: "Name question is required", buttons: nil)
            return
        }
        
        if arrayTextFields.count == 0 {
            self.showAlert("Need at least 1 question", title: "Error", buttons: nil)
            return
        }
        
        for textField in arrayTextFields {
            guard let nameQuestion = textField.text, textField.hasText == true else {
                return
            }
            
            let question = QuestionObject()
            question.question = nameQuestion
            questions.append(question)
        }
        
        test.name = name
        test.questions = questions
       
        loading.showLoadingDialog(self)
        TestServices.shared.newTest(withTest: test) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "New question error", buttons: nil)
                return
            }
            self.showAlert("New question has been successfully", title: "New question success", buttons: nil)
        }
        
    }

    @IBAction func btnNewQuestion(_ sender: Any) {
        if arrayTextFields.count != 0 {
            if !arrayTextFields[arrayTextFields.count - 1].hasText {
                self.showAlert("Please enter name question", title: "Fields are required", buttons: nil)
                return
            }
            addTextField()
            return
        }
        addTextField()
        
    }
}
