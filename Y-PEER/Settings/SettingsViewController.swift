//
//  SettingsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Toaster

class SettingsViewController: ParentViewController {
    
    var heights: [IndexPath:CGFloat] = [:]
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.backgroundColor = .mainGray
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = 100
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: SettingsNotificationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingsNotificationTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: SettingsLanguageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingsLanguageTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: SettingsTableViewHeader.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: SettingsTableViewHeader.self))
        }
    }

    @IBOutlet weak var doneButtoon: UIBarButtonItem!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var languages = ["English", "العربية"]
    var messages = ["You need to restart the application for the changes to appear", "يجب اعادة تشغبل التطبيق لتظهر التغييرات"]
    var titles = ["Restart required", "اعادة التشغيل"]
    var notificationSettingsTitles = ["Send notifications when we post something new".localized, "Send notifications a new event is happening".localized, "Send notifications a new quiz is available".localized]
    var selectedLanguage: Int = Cache.language.current.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings".localized
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource, SettingsNotificationTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsNotificationTableViewCell.self)) as? SettingsNotificationTableViewCell{
                cell.index = indexPath
                cell.cellLabel.text = notificationSettingsTitles[indexPath.row]
                cell.delegate = self
                let settings = Cache.settings.current
                switch indexPath.row{
                case 0:
                    cell.toggle.isOn = settings[0] == 1
                    break
                case 1:
                    cell.toggle.isOn = settings[1] == 1
                    break
                case 2:
                    cell.toggle.isOn = settings[2] == 1
                    break
                default:
                    break
                }
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsLanguageTableViewCell.self)) as? SettingsLanguageTableViewCell{
                cell.cellLabel.text = languages[indexPath.row]
                cell.isRadioSelected = indexPath.row == selectedLanguage
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            return
        }
        if selectedLanguage == indexPath.row{
            return
        }
        Cache.language.changeLanguage(language: Cache.language.Language(rawValue: indexPath.row)!)
        showAlert(titles[indexPath.row], messages[indexPath.row])
        selectedLanguage = indexPath.row
        if let token = Messaging.messaging().fcmToken{
            Networking.sendSettings(token) { (model) in
                if model != nil{
                    if model!.code == "1"{
                        //Something
                    }
                    else{
                        if self.selectedLanguage == 0{
                            self.selectedLanguage = 1
                        }
                        else{
                            self.selectedLanguage = 0
                        }
                        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1)], with: .none)
                        Toast(text: model!.message).show()
                    }
                }
                else{
                    if self.selectedLanguage == 0{
                        self.selectedLanguage = 1
                    }
                    else{
                        self.selectedLanguage = 0
                    }
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1)], with: .none)
                    Toast(text: "ERROR CONNECT MESSAGE".localized).show()
                }
            }
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SettingsTableViewHeader.self)) as? SettingsTableViewHeader{
            if section == 0{
                header.headerLabel.text = "Notifications Settings".localized
                header.headerImageView.image = UIImage(named: "alarm")
            }
            else{
                header.headerLabel.text = "Language Settings".localized
                header.headerImageView.image = UIImage(named: "GlobeOrange")
            }
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heights[indexPath] = cell.bounds.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.heights[indexPath] {
            return height
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func didToggle(at indexPath: IndexPath, with state: Bool) {
        if let token = Messaging.messaging().fcmToken{
            switch indexPath.row {
            case 0:
                Cache.settings.setPosts(state ? 1 : 0)
                Networking.sendSettings(token) { (model) in
                    if model != nil{
                        if model!.code == "1"{
                            //Something
                        }
                        else{
                            Cache.settings.setPosts(state ? 0 : 1)
                            let cell = self.tableView.cellForRow(at: indexPath) as! SettingsNotificationTableViewCell
                            cell.toggle.setOn(!state, animated: true)
                            Toast(text: model!.message).show()
                        }
                    }
                    else{
                        Cache.settings.setPosts(state ? 0 : 1)
                        let cell = self.tableView.cellForRow(at: indexPath) as! SettingsNotificationTableViewCell
                        cell.toggle.setOn(!state, animated: true)
                        Toast(text: "ERROR CONNECT MESSAGE".localized).show()
                    }
                }
                break
            case 1:
                Cache.settings.setEvents(state ? 1 : 0)
                Networking.sendSettings(token) { (model) in
                    if model != nil{
                        if model!.code == "1"{
                            //Something
                        }
                        else{
                            Cache.settings.setEvents(state ? 0 : 1)
                            let cell = self.tableView.cellForRow(at: indexPath) as! SettingsNotificationTableViewCell
                            cell.toggle.setOn(!state, animated: true)
                            Toast(text: model!.message).show()
                        }
                    }
                    else{
                        Cache.settings.setEvents(state ? 0 : 1)
                        let cell = self.tableView.cellForRow(at: indexPath) as! SettingsNotificationTableViewCell
                        cell.toggle.setOn(!state, animated: true)
                        Toast(text: "ERROR CONNECT MESSAGE".localized).show()
                    }
                }
                break
            case 2:
                Cache.settings.setQuiz(state ? 1 : 0)
                Networking.sendSettings(token) { (model) in
                    if model != nil{
                        if model!.code == "1"{
                            //Something
                        }
                        else{
                            Cache.settings.setQuiz(state ? 0 : 1)
                            let cell = self.tableView.cellForRow(at: indexPath) as! SettingsNotificationTableViewCell
                            cell.toggle.setOn(!state, animated: true)
                            Toast(text: model!.message).show()
                        }
                    }
                    else{
                        Cache.settings.setQuiz(state ? 0 : 1)
                        let cell = self.tableView.cellForRow(at: indexPath) as! SettingsNotificationTableViewCell
                        cell.toggle.setOn(!state, animated: true)
                        Toast(text: "ERROR CONNECT MESSAGE".localized).show()
                    }
                }
                break
            default:
                break
            }
        }
    }
    
}
