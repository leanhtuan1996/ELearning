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
    var refreshControl = UIRefreshControl()
    let loading = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblTests.delegate = self
        tblTests.dataSource = self
        tblTests.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        tblTests.estimatedRowHeight = 80
        
        //pull to refresh
        refreshControl.addTarget(self, action: #selector(loadTests), for: .valueChanged)
        
        tblTests.refreshControl = refreshControl
        
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        loadTests()
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadTests() {
        TestServices.shared.getTests { (tests, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.tests = tests ?? []
            self.tblTests.reloadData()
            self.refreshControl.endRefreshing()
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
        //cell.lblByTeacherName.text = tests[indexPath.row].byTeacher?.fullname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "DetailTestVC") as? DetailTestVC {
            
            guard let id = tests[indexPath.row].id else {
                return
            }
            
            TestServices.shared.getTest(withId: id, completionHandler: { (test, error) in
                if let error = error {
                    self.showAlert(error, title: "Load test fail", buttons: nil)
                    return
                }
                
                sb.mytest = test
                self.addChildViewController(sb)
                sb.view.frame = self.view.frame
                self.view.addSubview(sb.view)
                sb.didMove(toParentViewController: self)
                sb.view.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
                
            })
        }
    }
    
    
}
