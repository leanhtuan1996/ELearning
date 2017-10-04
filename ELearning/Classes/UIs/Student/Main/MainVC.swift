//
//  MainVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    
    @IBOutlet weak var tblTests: UITableView!
    var tests: [TestObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblTests.delegate = self
        tblTests.dataSource = self
        tblTests.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        tblTests.estimatedRowHeight = 80
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadTests()
    }

    func loadTests() {
        UserServices.shared.getTests { (tests, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.tests = tests ?? []
            self.tblTests.reloadData()
        }
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as? TestCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = tests[indexPath.row].name
        cell.lblTotalContent.text = tests[indexPath.row].content?.count.toString()
        
        return cell
    }
}
