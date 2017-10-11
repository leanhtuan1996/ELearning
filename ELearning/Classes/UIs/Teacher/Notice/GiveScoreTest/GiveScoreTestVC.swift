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
}

extension GiveScoreTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as? AnswerCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = self.test.questions?[indexPath.row].question
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let popup = storyboard?.instantiateViewController(withIdentifier: "PopupGiveScoreVC") as? PopupGiveScoreVC, let answer = self.test.answers?[indexPath.row], let questionName = test.questions?[indexPath.row].question else {
            print("PopupGiveScore not found")
            return
        }
        
        //print(test.questions?[indexPath.row].question)
        popup.idStudent = studentId
        popup.answer = answer
        popup.questionName = questionName
        self.addChildViewController(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParentViewController: self)
        
        popup.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
    }
}
