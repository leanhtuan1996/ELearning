//
//  DetailTestVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/5/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class DetailTestVC: UIViewController {
    
    var mytest: TestObject?
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var tblQuestions: UITableView!
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeAnimate))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.layer.cornerRadius = 5
        showAnimate()
        self.view.addGestureRecognizer(tapGesture)
        
        tblQuestions.delegate = self
        tblQuestions.dataSource = self
        tblQuestions.estimatedRowHeight = 40
        
        tblQuestions.register(UINib(nibName: "QuestionsCell", bundle: nil), forCellReuseIdentifier: "QuestionsCell")
    }
    
    @IBAction func back(_ sender: Any) {
        removeAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        lblName.text = mytest?.name
        
        if let teacherId = mytest?.byTeacher?.id {
            getInfoTeacher(withId: teacherId)
        }
        
    }
    @IBAction func btnJoinTestTapped(_ sender: Any) {
        guard let id = mytest?.id else {
            return
        }
        
        TestServices.shared.joinTest(withId: id) { (isJoin, error) in
            if let error = error {
                self.showAlert(error, title: "Join this test failed", buttons: nil)
                return
            }
            
            let answerTest = UIAlertAction(title: "Answer test now", style: UIAlertActionStyle.default, handler: { (btn) in
                self.showAnswerTest()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            if let isJoin = isJoin {
                if isJoin {
                    self.showAlert("This test had been joined!", title: "Join this test error", buttons: [answerTest, cancel])
                    return
                }
            }
            
            self.showAlert("Join test successfully! You can answer test now", title: "Join test successfully", buttons: [answerTest, cancel])
            return
            
        }
    }
    
    func showAnswerTest() {
        if let sb = self.storyboard?.instantiateViewController(withIdentifier: "AnswerTestVC") as? AnswerTestVC {
            sb.test = mytest
            self.navigationController?.pushViewController(sb, animated: true)
            self.tabBarController?.hidesBottomBarWhenPushed = true
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished) in
            if finished
            {
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
    
    func getInfoTeacher(withId id: String) {
        UserServices.shared.getInformations(byId: id) { (user, error) in
            if let _ = error {
                self.lblBy.text = "User is not available."
                return
            }
            
            if let user = user {
                self.mytest?.byTeacher = user
                DispatchQueue.main.async {
                    self.lblBy.text = user.fullname ?? "Chưa rõ danh tính"
                }
            } else {
                self.lblBy.text = "User is not available."
            }
        }
    }
}

extension DetailTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let contents = mytest?.questions {
            return contents.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsCell", for: indexPath) as? QuestionsCell else {
            return UITableViewCell()
        }
        
        cell.lblQuestion.text = mytest?.questions?[indexPath.row].question
        return cell
    }
}
