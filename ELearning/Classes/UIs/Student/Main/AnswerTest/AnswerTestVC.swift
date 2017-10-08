//
//  AnswerTestVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class AnswerTestVC: UIViewController {
    
    var test: TestObject?
    let loading = UIActivityIndicatorView()
    @IBOutlet weak var tblQuestions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblQuestions.delegate = self
        tblQuestions.dataSource = self
        tblQuestions.register(UINib(nibName: "AnswerQuestionCell", bundle: nil), forCellReuseIdentifier: "AnswerQuestionCell")
        tblQuestions.estimatedRowHeight = 80
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadTest()
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadTest() {
        guard let test = test, let id = test.id else {
            return
        }
        loading.showLoadingDialog(self)
        TestServices.shared.loadTest(withId: id) { (test, error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Get test error", buttons: nil)
                return
            }
            
            self.test = test
            self.tblQuestions.reloadData()
        }
    }
    
    func showPopupRecording() {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "PopupRecordQuestionVC") as? PopupRecordQuestionVC {
            self.addChildViewController(sb)
            sb.view.frame = self.view.frame
            self.view.addSubview(sb.view)
            sb.didMove(toParentViewController: self)
            sb.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
            
        }
    }
    
    func pushAnswer() {
        
    }
    
    func statusQuestionHandler(withQuestion question: QuestionObject) -> String {
        if let answers = test?.answers, let idQuestion = question.id {
            if answers.contains(where: { (answer) -> Bool in
                if let id = answer.questionId {
                    return id == idQuestion
                }
                return false
                
            }) {
                return "Completed"
            } else {
                return "Not completed yet"
            }
        }
        return "Not completed yet"
    }
    
}


extension AnswerTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test?.questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerQuestionCell", for: indexPath) as? AnswerQuestionCell else {
            return UITableViewCell()
        }
        
        if let questions = test?.questions {
            cell.question = questions[indexPath.row]
            cell.lblStatus.text = statusQuestionHandler(withQuestion: questions[indexPath.row])
            cell.lblQuestion.text = questions[indexPath.row].question
        }
        
        return cell
    }
}

protocol AnswerQuestionTestDelegate {
    func recordQuestion() -> Void
    func submitRecord() -> Void
}
