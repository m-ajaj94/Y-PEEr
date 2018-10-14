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
    
    var selectedLanguage: Int = 0
    var languages = ["English", "العربية"]
    
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
        if indexPath.section == 0{
            return
        }
        selectedLanguage = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SettingsTableViewHeader.self)) as? SettingsTableViewHeader{
            if section == 0{
                header.headerLabel.text = "Notifications Settings"
            }
            else{
                header.headerLabel.text = "Language Settings"
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
