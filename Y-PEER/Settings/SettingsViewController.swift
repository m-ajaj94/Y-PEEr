//
//  SettingsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SettingsViewController: ParentViewController {
    
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
    var notificationSettingsTitles = ["Notification-1".localized, "Notification-2".localized, "Notification-3".localized, ]
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
        Cache.language.changeLanguage(language: Cache.language.Language(rawValue: indexPath.row)!)
        showAlert(titles[indexPath.row], messages[indexPath.row])
        selectedLanguage = indexPath.row
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func didToggle(at indexPath: IndexPath, with state: Bool) {
        
    }
    
}
