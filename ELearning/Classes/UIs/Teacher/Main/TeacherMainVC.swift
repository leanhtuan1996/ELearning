//
//  TeacherMainVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/4/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class TeacherMainVC: UIViewController {

    @IBOutlet weak var tblTests: UITableView!
    
    var tests: [TestObject] = []
    let loading = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblTests.delegate = self
        tblTests.dataSource = self
        tblTests.register(UINib(nibName: "MyTestCell", bundle: nil), forCellReuseIdentifier: "MyTestCell")
        tblTests.estimatedRowHeight = 80
        
        
        //tabbar
        if let items = tabBarController?.tabBar.items {
            let tabBarImages = [#imageLiteral(resourceName: "listTest"), #imageLiteral(resourceName: "alert"), #imageLiteral(resourceName: "setting")]
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = tabBarImage
                tabBarItem.imageInsets = UIEdgeInsets( top: 5, left: 0, bottom: -5, right: 0)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        loadMyTests()
    }
    
    
    // MARK: - FUNCTIONS
    func loadMyTests() {
        loading.showLoadingDialog(self)
        TestServices.shared.getMyTests { (tests, error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Error", buttons: nil)
                return
            }
            
            if let tests = tests {
                self.tests = tests
                self.tblTests.reloadData()
            }
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func btnAddTestTapped(_ sender: Any) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "NewTestVC") as? NewTestVC {
            self.navigationController?.pushViewController(sb, animated: true)
        }
    }
    
}

extension TeacherMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTestCell", for: indexPath) as? MyTestCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = tests[indexPath.row].name
        
        if let results = tests[indexPath.row].results {
            cell.lblTotal.text = results.count.toString()
        }
        
        return cell
    }
}
