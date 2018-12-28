//
//  StoriesViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class StoriesViewController: ParentViewController {

    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshRequest), for: .valueChanged)
            tableView.refreshControl = refreshControl
            tableView.addInfiniteScroll { (tableView) in
                self.moreRequest()
            }
            tableView.register(UINib(nibName: String(describing: StoriesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: StoriesTableViewCell.self))
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreateStory", sender: self)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var stories: [StoryModel]!{
        didSet{
            tableView.reloadData()
        }
    }
    let pageSize = 10
    var refreshControl: UIRefreshControl!
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: "ShowStoryDetails", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stories".localized
        requestData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonContainerView.layer.cornerRadius = buttonContainerView.frame.height / 2
    }
    
    @objc func requestData(){
        showLoading()
        Networking.stories.getStories(["skip":0, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.stories = model!.data!
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
        Networking.stories.getStories(["skip":0, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            self.refreshControl.endRefreshing()
            if model != nil{
                if model!.code == "1"{
                    self.stories = model!.data!
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "ERROR MESSAGE".localized).show()
            }
        }
    }
    
    @objc override func didPressRetry() {
        self.removeNoConnection()
        self.requestData()
    }
    
    func moreRequest(){
        Networking.stories.getStories(["skip":stories.count, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.stories.append(contentsOf: model!.data!)
                    self.tableView.finishInfiniteScroll()
                    self.tableView.reloadData()
                }
                else{
                    Toast(text: model!.message).show()
                }
            }
            else{
                Toast(text: "Error Message TODO".localized).show()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStoryDetails"{
            let controller = segue.destination as! StoryDetailsViewController
            controller.story = stories[selectedIndex.row]
        }
    }

}

extension StoriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stories == nil{
            return 0
        }
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoriesTableViewCell.self)) as! StoriesTableViewCell
        cell.story = stories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
    }
    
}
