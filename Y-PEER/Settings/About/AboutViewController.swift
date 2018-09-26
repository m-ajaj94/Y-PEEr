//
//  AboutViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class AboutViewController: ParentViewController {
    
    private let coreTeamSegueIdentifier = "ShowCoreTeam"

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.backgroundColor = .mainGray
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.sectionHeaderHeight = UITableViewAutomaticDimension
            tableView.estimatedSectionHeaderHeight = 80
            tableView.register(UINib(nibName: String(describing: AboutTableViewSectionHeader.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: AboutTableViewSectionHeader.self))
            tableView.register(UINib(nibName: String(describing: AboutDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutDetailsTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: AboutCoreTeamTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutCoreTeamTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: AboutPartnershipTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutPartnershipTableViewCell.self))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Us".localized
    }

}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutDetailsTableViewCell.self)) as? AboutDetailsTableViewCell{
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutDetailsTableViewCell.self)) as? AboutDetailsTableViewCell{
                return cell
            }
            break
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutCoreTeamTableViewCell.self)) as? AboutCoreTeamTableViewCell{
                return cell
            }
            break
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutPartnershipTableViewCell.self)) as? AboutPartnershipTableViewCell{
                return cell
            }
            break
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: AboutTableViewSectionHeader.self)) as? AboutTableViewSectionHeader{
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            performSegue(withIdentifier: coreTeamSegueIdentifier, sender: self)
            break
        default:
            break
        }
    }
    
}
