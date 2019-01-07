//
//  QuizzesViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/14/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SkeletonView
import Toaster

class QuizzesViewController: ParentViewController {
    
    var heights: [IndexPath:CGFloat] = [:]

    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        if let tabController = tabBarController as? MainTabBarController{
            tabController.showSideMenu()
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            if tableView != nil{
                tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                tableView.isSkeletonable = true
                tableView.delegate = self
                tableView.dataSource = self
                refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                tableView.refreshControl = refreshControl
                tableView.separatorStyle = .none
                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 260
                tableView.register(UINib(nibName: String(describing: PostsSkeletonTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsSkeletonTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsQuizTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsQuizTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostImageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostImageTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsUpcomingEventTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsUpcomingEventTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsTextTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsTextTableViewCell.self))
            }
        }
    }
    
    var refreshControl: UIRefreshControl!
    let pageSize = 10
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: "ShowQuiz", sender: self)
        }
    }
    
    var quizzes: [QuizModel]!{
        didSet{
            tableView.reloadData()
        }
    }
    
    @objc override func didPressRetry() {
        removeNoConnection()
        requestData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes".localized
        requestData()
        tableView.addInfiniteScroll { (tableView) in
            self.moreData()
        }
    }
    
    @objc func refreshData(){
        Networking.quiz.getQuizzes(["skip":0, "take":pageSize]) { (model) in
            self.refreshControl.endRefreshing()
            if model != nil{
                if model!.code == "1"{
                    self.quizzes = model!.data!
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
    
    func requestData(){
        showLoading()
        Networking.quiz.getQuizzes(["skip":0, "take":pageSize]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.quizzes = model!.data!
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
    
    func moreData(){
        Networking.quiz.getQuizzes(["skip":quizzes.count, "take":pageSize]) { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.quizzes.append(contentsOf: model!.data!)
                    self.tableView.finishInfiniteScroll()
                    self.tableView.reloadData()
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
        if segue.identifier == "ShowQuiz"{
            let controller = segue.destination as! QuizViewController
            controller.title = quizzes[selectedIndex.row].title!
            controller.quizID = quizzes[selectedIndex.row].id!
        }
    }

}

extension QuizzesViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate, PostsQuizTableViewCellDelegate{
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: PostsSkeletonTableViewCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizzes != nil{
            return quizzes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsQuizTableViewCell.self)) as? PostsQuizTableViewCell{
            cell.delegate = self
            cell.index = indexPath
            cell.quiz = quizzes[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
    }
        
    func didTapStartFromQuiz(at indexPath: IndexPath) {
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
