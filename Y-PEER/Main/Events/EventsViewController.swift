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
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshRequest), for: .valueChanged)
            tableView.refreshControl = refreshControl
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
        filterMode = 1
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
        filterMode = 3
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
        filterMode = 2
    }
    
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: "ShowPostDetails", sender: self)
        }
    }
    var events: [EventDataModel]!
    var data: [EventDataModel]!{
        didSet{
            setData()
        }
    }
    let pageSize = 10
    var refreshControl: UIRefreshControl!
    var filterMode: Int!{
        didSet{
            setData()
        }
    }
    
    func setData(){
        switch filterMode {
        case 1:
            events = data
            break
        case 2:
            events = []
            for event in data{
                if event.type! == "passed"{
                    events.append(event)
                }
            }
            break
        case 3:
            events = []
            for event in data{
                if event.type! != "passed"{
                    events.append(event)
                }
            }
            break
        default:
            break
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterMode = 1
        title = "Events".localized
        requestData()
        tableView.addInfiniteScroll { (tableView) in
            self.moreRequest()
        }
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
    
    @objc func refreshRequest(){
        Networking.events.getEvents(["skip":0, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            self.refreshControl.endRefreshing()
            if model != nil{
                if model!.code == "1"{
                    self.data = model!.data!
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "ERROR CONNECT MESSAGE".localized).show()
            }
        }
    }
    
    func moreRequest(){
        Networking.events.getEvents(["skip":data.count, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.data.append(contentsOf: model!.data!)
                    self.tableView.finishInfiniteScroll()
                    self.tableView.reloadData()
                    self.setData()
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "ERROR CONNECT MESSAGE".localized).show()
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
        controller.event = data[selectedIndex.row]
        if events[selectedIndex.row].type! == "passed"{
            controller.type = PostType.pastEvent
        }
        else{
            controller.type = PostType.event
        }
    }

}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events == nil{
            return 0
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventsTableViewCell.self)) as? EventsTableViewCell{
            if events[indexPath.row].type! == "passed"{
                cell.type = PostType.pastEvent
            }
            else{
                cell.type = PostType.event
            }
            cell.event = events[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}
