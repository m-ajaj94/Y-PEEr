//
//  PostsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SkeletonView
import Toaster

class PostsViewController: ParentViewController {
    
    var heights: [IndexPath:CGFloat] = [:]

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            if tableView != nil{
                tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                tableView.isSkeletonable = true
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = UITableView.automaticDimension
                refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(refreshRequest), for: .valueChanged)
                tableView.refreshControl = refreshControl
                tableView.register(UINib(nibName: String(describing: PostsSkeletonTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsSkeletonTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsQuizTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsQuizTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostImageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostImageTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsUpcomingEventTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsUpcomingEventTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsTextTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsTextTableViewCell.self))
            }
        }
    }
    @IBOutlet weak var sidemenuButton: UIBarButtonItem!
    
    @IBAction func sideMenuButtonPressed(_ sender: UIBarButtonItem) {
        if let tabController = tabBarController as? MainTabBarController{
            tabController.showSideMenu()
        }
    }
    
    var selectedIndex: IndexPath!{
        didSet{
            switch types[selectedIndex.row] {
            case .event:
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventDetailsViewController.self)) as! EventDetailsViewController
                controller.event = posts[selectedIndex.row].event!
                controller.images = posts[selectedIndex.row].images!
                navigationController!.pushViewController(controller, animated: true)
            case .post:
                performSegue(withIdentifier: "ShowPostDetails", sender: self)
                break
            case .quiz:
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: QuizViewController.self)) as! QuizViewController
                controller.quizID = posts[selectedIndex.row].quiz!.id!
                navigationController!.pushViewController(controller, animated: true)
                break
            case .pastEvent:
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventDetailsViewController.self)) as! EventDetailsViewController
                controller.event = posts[selectedIndex.row].event!
                controller.images = posts[selectedIndex.row].images!
                navigationController!.pushViewController(controller, animated: true)
            }
        }
    }
    
    var posts: [PostModel]!{
        didSet{
            if posts != nil{
                setPostsTypes()
                tableView.reloadData()
            }
        }
    }
    var types: [PostType]!
    let pageSize = 10
    var refreshControl: UIRefreshControl!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if posts == nil{
//            view.showAnimatedGradientSkeleton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.hideSkeleton(reloadDataAfter: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Newsfeed".localized
        requestData()
        tableView.addInfiniteScroll { (tableView) in
            self.moreRequest()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(likeStatus(_:)), name: NSNotification.Name("LikeChanged"), object: nil)
    }
    
    @objc func likeStatus(_ notification: Notification){
        let postID: Int = notification.userInfo!["id"] as! Int
        for post in posts{
            if postID == post.id!{
                post.totalLikes = (notification.userInfo!["count"] as! Int)
                post.isLiked = (notification.userInfo!["liked"] as! Bool) ? "1" : "0"
            }
        }
    }
    
    @objc func requestData(){
        showLoading()
        Networking.posts.homePosts(["skip":0, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code == "1"{
                    self.posts = model!.data!
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
        Networking.posts.homePosts(["skip":0, "take":10, "user_id":UserCache.userID]) { (model) in
            self.refreshControl.endRefreshing()
            if model != nil{
                if model!.code == "1"{
                    self.posts = model!.data!
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
        Networking.posts.homePosts(["skip":posts.count, "take":pageSize, "user_id":UserCache.userID]) { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.posts.append(contentsOf: model!.data!)
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
    
    func setPostsTypes(){
        var array: [PostType] = []
        for post in posts{
            if post.eventID != nil && post.eventID! != 0{
                array.append(.event)
            }
            else if post.quizID != nil && post.quizID! != 0{
                array.append(.quiz)
            }
            else{
                array.append(.post)
            }
        }
        types = array
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostDetails"{
            if let controller = segue.destination as? PostDetailsViewController{
                controller.post = posts[selectedIndex.row]
            }
        }
    }

}

extension PostsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate, PostsQuizTableViewCellDelegate, PostImageTableViewCellDelegate, PostsUpcomingEventTableViewCellDelegate, PostsTextTableViewCellDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: PostsSkeletonTableViewCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isSkeletonActive{
            return 5
        }
        if posts != nil{
            return posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch types[indexPath.row]{
        case .event:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsUpcomingEventTableViewCell.self)) as! PostsUpcomingEventTableViewCell
            cell.post = posts[indexPath.row]
            cell.index = indexPath
            cell.delegate = self
            return cell
        case .pastEvent:
            //TODO: past event
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsUpcomingEventTableViewCell.self)) as! PostsUpcomingEventTableViewCell
            return cell
        case .quiz:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsQuizTableViewCell.self)) as! PostsQuizTableViewCell
            cell.quiz = posts[indexPath.row].quiz!
            return cell
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostImageTableViewCell.self)) as! PostImageTableViewCell
            cell.delegate = self
            cell.index = indexPath
            cell.post = posts[indexPath.row]
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
    }
    
    func didTapStartFromQuiz(at indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    func didPressLike(at index: IndexPath) {
        if UserCache.isLoggedIn{
            if posts[index.row].isLiked! == "0"{
                Networking.posts.likePost(["post_id":posts[index.row].id!,"user_id":UserCache.userID]) { (model) in
                    if model != nil && model!.code! == "1"{
                        self.posts[index.row].isLiked = "1"
                        self.posts[index.row].totalLikes = model!.data!.likesCount!
                        NotificationCenter.default.post(name: NSNotification.Name("LikeChanged"), object: nil, userInfo: ["id":self.posts[index.row].id!,"count":model!.data!.likesCount!, "liked":true])
                    }
                    else{
                        if model == nil{
                            Toast(text: "Error Message").show()
                        }
                        else{
                            Toast(text: model!.message!).show()
                        }
                    }
                }
            }
            else{
                Networking.posts.dislikePost(["post_id":posts[index.row].id!,"user_id":UserCache.userID]) { (model) in
                    if model != nil && model!.code! == "1"{
                        self.posts[index.row].isLiked = "1"
                        self.posts[index.row].totalLikes = model!.data!.likesCount!
                        NotificationCenter.default.post(name: NSNotification.Name("LikeChanged"), object: nil, userInfo: ["id":self.posts[index.row].id!,"count":model!.data!.likesCount!, "liked":false])
                    }
                    else{
                        if model == nil{
                            Toast(text: "Error Message").show()
                        }
                        else{
                            Toast(text: model!.message!).show()
                        }
                    }
                }
            }
        }
        else{
            let navController = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let controller = navController.viewControllers[0] as! SigninViewController
            controller.isModal = true
            present(navController, animated: true, completion: nil)
        }
    }
    
    func didSeletImage(at index: IndexPath, from originalIndex: IndexPath) {
        let images = posts[originalIndex.row].images!
        showImages(images, index.row)
    }
    
    func didTapImage(at index: IndexPath) {
        let images = posts[index.row].images!
        showImages(images, 0)
    }
    
    
}

enum PostType{
    case event
    case pastEvent
    case quiz
    case post
}
