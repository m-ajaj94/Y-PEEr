//
//  IssueViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class IssueViewController: ParentViewController {
    
    var heights: [IndexPath:CGFloat] = [:]
    
    private let showArticleSegueIdentifier = "ShowArticle"

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.shadowOpacity = 0.5
            containerView.layer.shadowRadius = 5
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            tableView.register(UINib(nibName: String(describing: IssueTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IssueTableViewCell.self))
            tableView.backgroundColor = .mainGray
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
            tableView.addInfiniteScroll { (tableView) in
                self.moreData()
            }
        }
    }
    var refreshControl: UIRefreshControl!
    var articles: [ArticleModel]!{
        didSet{
            tableView.reloadData()
        }
    }
    let pageSize = 10
    var issue: IssueModel!
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: showArticleSegueIdentifier, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = issue.title!
        titleLabel.text = issue.title!
        detailsLabel.text = issue.description!
        requestData()
    }
    
    override func didPressRetry() {
        removeNoConnection()
        requestData()
    }
    
    func requestData(){
        let dict = ["issue_id":issue.id!, "user_id":UserCache.userID, "skip":0, "take":pageSize]
        showLoading()
        Networking.issues.getArticles(dict) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.articles = model!.data!
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
    
    @objc func refreshData(){
        let dict = ["issue_id":issue.id!, "user_id":UserCache.userID, "skip":0, "take":pageSize]
        Networking.issues.getArticles(dict) { (model) in
            self.refreshControl.endRefreshing()
            if model != nil{
                if model!.code == "1"{
                    self.articles = model!.data!
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
    
    func moreData(){
        let dict = ["issue_id":issue.id!, "user_id":UserCache.userID, "skip":articles.count, "take":pageSize]
        Networking.issues.getArticles(dict) { (model) in
            self.tableView.finishInfiniteScroll()
            if model != nil{
                if model!.code == "1"{
                    self.articles.append(contentsOf: model!.data!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showArticleSegueIdentifier{
            let controller = segue.destination as! IssueArticleViewController
            controller.article = articles[selectedIndex.row]
        }
    }

}

extension IssueViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles == nil{
            return 0
        }
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IssueTableViewCell.self)) as? IssueTableViewCell{
            cell.article = articles[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
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
    
}
