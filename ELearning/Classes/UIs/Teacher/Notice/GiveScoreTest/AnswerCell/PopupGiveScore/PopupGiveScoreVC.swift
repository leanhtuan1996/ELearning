//
//  PopupGiveScoreVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PopupGiveScoreVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnListen: UIButton!
    @IBOutlet weak var txtScore: UITextField!
    
    var idTest: String?
    var idStudent: String?
    var questionName: String?
    var answer = AnswerObject()
    var isListening: Bool = false
    let loading = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblName.text = questionName
    }

    
    @IBAction func btnListenTapped(_ sender: Any) {
        if isListening {
            //stop
            return
        }
        //start listen
        
    }
    @IBAction func btnDone(_ sender: Any) {
        if isListening {
            return
        }
        
        guard let testId = self.idTest, let questionId = self.answer.questionId, let studentId = self.idStudent, txtScore.hasText == true, let scoreString = txtScore.text, let score = scoreString.toInt() else {
            return
        }
        loading.showLoadingDialog(self)
        TestServices.shared.giveScore(withTestId: testId, withStudentId: studentId, withQuestionId: questionId, withScore: score) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Give Score has been failed", buttons: nil)
                return
            }
            let returnButton = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.closePopup()
            })
            self.showAlert("Give score has been successfully!", title: "Success", buttons: [returnButton])
        }
        
    }
    
    func closePopup() {
        self.didMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }

    @IBAction func btnCloseTapped(_ sender: Any) {
        closePopup()
    }
}
