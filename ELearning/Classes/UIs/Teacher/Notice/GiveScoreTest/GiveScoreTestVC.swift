//
//  GiveScoreTestVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class GiveScoreTestVC: UIViewController {
    
    @IBOutlet weak var tblListQuestions: UITableView!
    
    @IBOutlet weak var lblNameOfStudent: UILabel!
    var test = TestObject()
    var studentId: String?
    let loading = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblListQuestions.delegate = self
        tblListQuestions.dataSource = self
        tblListQuestions.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tblListQuestions.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadResultTest()
        loadStudent()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func loadResultTest() {
        guard let testId = test.id, let studentId = self.studentId else {
            return
        }
        loading.showLoadingDialog(self)
        TestServices.shared.loadResult(withStudentId: studentId, withTestId: testId) { (test, error) in
            self.loading.stopAnimating()
            if let error = error {
                print(error)
                return
            }
            guard let test = test else {
                print("test not found")
                return
            }
            self.test = test
            self.tblListQuestions.reloadData()
        }
    }
    
    func loadStudent() {
        guard let studentId = self.studentId else {
            print("StudentId not found")
            return
        }
        
        UserServices.shared.getInformations(byId: studentId) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let user = user else {
                print("User not found")
                return
            }
            
            DispatchQueue.main.async {
                self.lblNameOfStudent.text = user.fullname
            }
            
        }
    }
    
    func loadAnswerVoice(withFileName path: String) {
        
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GiveScoreTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let results = test.results else {
            return 0
        }
        
        if results.count == 0 {
            return 0
        }
        
        return results[0].answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as? AnswerCell, let results = test.results else {
            return UITableViewCell()
        }
        
        cell.lblName.text = self.test.questions?[indexPath.row].question
        if results[0].answers?[indexPath.row].score == nil {
            cell.lblStatus.text = "Not graded"
            cell.lblStatus.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            cell.lblStatus.text = "Graded"
            cell.lblStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let results = test.results else {
            return
        }
        
        if results[0].answers?[indexPath.row].score != nil {
            self.showAlert("This answer has been graded", title: "Error", buttons: nil)
            return
        }
        
        guard let popup = storyboard?.instantiateViewController(withIdentifier: "PopupGiveScoreVC") as? PopupGiveScoreVC, let answer = results[0].answers?[indexPath.row], let questionName = test.questions?[indexPath.row].question else {
            print("PopupGiveScore not found")
            return
        }
        
        loading.showLoadingDialog(self)
        TestServices.shared.getAnswerVoice(withAnswer: answer.fileName ?? "") { (data, error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Error", buttons: nil)
                return
            }
            
            if let data = data {
                popup.idStudent = self.studentId
                popup.answer = answer
                popup.questionName = questionName
                popup.dataAnswerVoiceURL = data
                popup.idTest = self.test.id
                self.addChildViewController(popup)
                popup.view.frame = self.view.frame
                self.view.addSubview(popup.view)
                popup.didMove(toParentViewController: self)
            } else {
                self.showAlert("Get Data Voice has been failed", title: "Error", buttons: nil)
                return
            }
        }
        
    }
}
