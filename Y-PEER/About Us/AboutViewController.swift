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
            tableView.rowHeight = UITableView.automaticDimension
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = 80
            tableView.register(UINib(nibName: String(describing: AboutTableViewSectionHeader.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: AboutTableViewSectionHeader.self))
            tableView.register(UINib(nibName: String(describing: AboutDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutDetailsTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: AboutCoreTeamTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutCoreTeamTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: AboutPartnershipTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AboutPartnershipTableViewCell.self))
        }
    }
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var aboutData: AboutDataModel!{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Us".localized
        requestData()
        let footer = AboutUsTableViewFooter.instanciateFromNib()
        footer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 48))
        footer.delegate = self
        tableView.tableFooterView = footer
    }
    
    func requestData(){
        showLoading()
        Networking.getAboutUs { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code! == "1"{
                    self.aboutData = model!.data!
                }
                else{
                    self.showNoConnection()
                }
            }
            else{
                self.showNoConnection()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == coreTeamSegueIdentifier{
            let controller = segue.destination as! CoreTeamViewController
            controller.members = aboutData.members!
        }
    }

}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aboutData == nil{
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutDetailsTableViewCell.self)) as? AboutDetailsTableViewCell{
                cell.cellImageView.image = UIImage(named: "1.png")
                cell.cellLabel.text = aboutData.text!
                return cell
            }
            break
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutDetailsTableViewCell.self)) as? AboutDetailsTableViewCell{
                cell.cellImageView.image = UIImage(named: "unfpa.png")
                cell.cellLabel.text = aboutData.partnership!
                return cell
            }
            break
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutCoreTeamTableViewCell.self)) as? AboutCoreTeamTableViewCell{
                cell.members = aboutData.members!
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

extension AboutViewController: AboutUsTableViewFooterDelegate{
    func didPressButton() {
        performSegue(withIdentifier: "ShowDevelopers", sender: self)
    }
}
