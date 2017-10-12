//
//  SettingsVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var tblSettings: UITableView!
    
    var settings: [SettingObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        tblSettings.dataSource = self
        tblSettings.delegate = self
        tblSettings.estimatedRowHeight = 50
        tblSettings.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
    }
    
    func loadSettings() {
        let updatePwSetting = SettingObject(name: "Update Password", type: SettingType.updatePw)
        let logoutSetting = SettingObject(name: "Log out", type: SettingType.logout)
        let updateInfo = SettingObject(name: "Update Informations", type: SettingType.updateInfo)
        
        settings = [updateInfo, updatePwSetting, logoutSetting]
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        
        cell.btnSetting.setTitle(settings[indexPath.row].name, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settings[indexPath.row].type {
        case .logout:
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.signOut()
            }
        case .updatePw:
            if let sb = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "UpdatePasswordVC") as? UpdatePasswordVC {
                self.navigationController?.pushViewController(sb, animated: true)
            }
        case .updateInfo:
            if let sb = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "UpdateInformationsVC") as? UpdateInformationsVC {
                self.navigationController?.pushViewController(sb, animated: true)
            }
            
        }
    }
}
