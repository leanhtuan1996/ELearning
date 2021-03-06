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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadTest() {
        guard let test = test, let id = test.id else {
            
            let returnButton = UIAlertAction(title: "Return", style: UIAlertActionStyle.default, handler: { (btn) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.showAlert("Id test not found", title: "Error", buttons: [returnButton])
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
    
    override func willMove(toParentViewController parent: UIViewController?) {
        loadTest()
    }
    
    func isCompleted(withQuestion question: QuestionObject) -> Bool {
        
        guard let results = test?.results else {
            return false
        }
        
        if let answers = results[0].answers, let idQuestion = question.id {
            if answers.contains(where: { (answer) -> Bool in
                if let id = answer.questionId {
                    return id == idQuestion
                }
                return false
                
            }) {
                return true
            }
        }
        return false
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
            
            if isCompleted(withQuestion: questions[indexPath.row]) {
                cell.lblStatus.text = "Completed"
                cell.lblStatus.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                cell.lblStatus.text = "Not completed yet"
                cell.lblStatus.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
            
            
            cell.lblQuestion.text = questions[indexPath.row].question
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let questions = test?.questions else {
            return
        }
        
        if !isCompleted(withQuestion: questions[indexPath.row]) {
            if let sb = storyboard?.instantiateViewController(withIdentifier: "PopupRecordQuestionVC") as? PopupRecordQuestionVC {
                sb.question = questions[indexPath.row]
                sb.idTest = test?.id
                self.addChildViewController(sb)
                sb.view.frame = self.view.frame
                self.view.addSubview(sb.view)
                sb.didMove(toParentViewController: self)
                sb.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
            }
        } else {
            self.showAlert("This question has been completed!", title: "Error", buttons: nil)
        }
    }
}
