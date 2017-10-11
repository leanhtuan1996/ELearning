//
//  NoticesVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/10/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class NoticesVC: UIViewController {

    @IBOutlet weak var tblNotices: UITableView!
    
    var notices: [NoticeObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotices.delegate = self
        tblNotices.dataSource = self
        tblNotices.register(UINib(nibName: "NoticeCell", bundle: nil), forCellReuseIdentifier: "NoticeCell")
        tblNotices.estimatedRowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUnseenNotices()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadUnseenNotices() {
        NoticeServices.shared.getUnSeenNotices { (notices, error) in
            if let error = error {
                self.showAlert(error, title: "Get notices has been failed", buttons: nil)
                return
            }
            
            if let notices = notices {
                self.notices = notices
                self.tblNotices.reloadData()
            }
        }
    }
}

extension NoticesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeCell else {
            return UITableViewCell()
        }
        
        cell.lblNoticeInfo.text = "\(notices[indexPath.row].test?.name ?? "") has just completed by student"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "GiveScoreTestVC") as? GiveScoreTestVC, let test = notices[indexPath.row].test else {
            return
        }
        
        vc.test = test
        vc.studentId = notices[indexPath.row].student?.id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
