//
//  PopupRecordQuestionVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class PopupRecordQuestionVC: UIViewController {

    var question: QuestionObject?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var imgRecord: UIImageView!
    @IBOutlet weak var lblQuestion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 5
        imgRecord.layer.cornerRadius = 100
    }
    @IBAction func btnDone(_ sender: Any) {
    }
}
