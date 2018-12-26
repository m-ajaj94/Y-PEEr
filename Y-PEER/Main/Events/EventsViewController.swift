//
//  EventsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/9/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class EventsViewController: ParentViewController {

    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        if let tabController = tabBarController as? MainTabBarController{
            tabController.showSideMenu()
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = .mainGray
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 200
            tableView.register(UINib(nibName: String(describing: EventsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EventsTableViewCell.self))
        }
    }
    @IBOutlet weak var passedButton: UIButton!{
        didSet{
            if passedButton != nil{
                passedButton.layer.borderColor = UIColor.mainOrange.cgColor
                passedButton.layer.borderWidth = 1
            }
        }
    }
    @IBOutlet weak var upcomingButton: UIButton!{
        didSet{
            if upcomingButton != nil{
                upcomingButton.layer.borderColor = UIColor.mainOrange.cgColor
                upcomingButton.layer.borderWidth = 1
            }
        }
    }
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            if allButton != nil{
                allButton.layer.borderColor = UIColor.mainOrange.cgColor
                allButton.layer.borderWidth = 1
            }
        }
    }
    @IBAction func allButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.allButton.backgroundColor = .mainOrange
            self.allButton.setTitleColor(.white, for: .normal)
            self.upcomingButton.backgroundColor = .white
            self.upcomingButton.setTitleColor(.mainOrange, for: .normal)
            self.passedButton.backgroundColor = .white
            self.passedButton.setTitleColor(.mainOrange, for: .normal)
        }
    }
    @IBAction func upcomingButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.upcomingButton.backgroundColor = .mainOrange
            self.upcomingButton.setTitleColor(.white, for: .normal)
            self.allButton.backgroundColor = .white
            self.allButton.setTitleColor(.mainOrange, for: .normal)
            self.passedButton.backgroundColor = .white
            self.passedButton.setTitleColor(.mainOrange, for: .normal)
        }
    }
    @IBAction func passedButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.passedButton.backgroundColor = .mainOrange
            self.passedButton.setTitleColor(.white, for: .normal)
            self.upcomingButton.backgroundColor = .white
            self.upcomingButton.setTitleColor(.mainOrange, for: .normal)
            self.allButton.backgroundColor = .white
            self.allButton.setTitleColor(.mainOrange, for: .normal)
        }
    }
    
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: "ShowPostDetails", sender: self)
        }
    }
    
    var data: [EventDataModel]!{
        didSet{
            tableView.reloadData()
        }
    }
    let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events".localized
        requestData()
    }
    
    override func didPressRetry() {
        removeNoConnection()
        requestData()
    }
    
    func requestData(){
        showLoading()
        Networking.events.getEvents(["skip":0, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.data = model!.data
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                self.showNoConnection()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allButton.layer.cornerRadius = allButton.frame.size.height / 2
        upcomingButton.layer.cornerRadius = upcomingButton.frame.size.height / 2
        passedButton.layer.cornerRadius = passedButton.frame.size.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! EventDetailsViewController
        controller.eventDetails = data[selectedIndex.row]
    }

}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data == nil{
            return 0
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventsTableViewCell.self)) as? EventsTableViewCell{
            cell.type = PostType.pastEvent
            cell.event = data[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}
