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
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.layer.cornerRadius = 5
    }
    
    func backToSupperview() {
        print("QUIT")
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func back(_ sender: Any) {
       backToSupperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        lblName.text = mytest?.name
        lblBy.text = mytest?.byTeacher?.fullname ?? " "
        lblCount.text = mytest?.content?.count.toString()
        lblStatus.text = "Chưa làm"
    }
    @IBAction func btnJoinTestTapped(_ sender: Any) {
    }
}
