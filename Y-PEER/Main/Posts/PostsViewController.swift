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
            if let cell = tableView.cellForRow(at: selectedIndex) as? PostsUpcomingEventTableViewCell{
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventDetailsViewController.self)) as! EventDetailsViewController
//                controller.imageName = cell.imageName
                navigationController!.pushViewController(controller, animated: true)
            }
            else{
                performSegue(withIdentifier: "ShowPostDetails", sender: self)
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
    }
    
    func requestData(){
//        view.showAnimatedSkeleton()
        Networking.posts.homePosts(["skip":0, "take":20]) { (model) in
            self.view.hideSkeleton(reloadDataAfter: false)
            if model != nil{
                if model!.code == "1"{
                    self.posts = model!.data!
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
//                if let cell = tableView.cellForRow(at: selectedIndex) as? PostImageTableViewCell{
////                    controller.passedImages = cell.images
//                    controller.passedImages = []
//                }
//                else{
//                    controller.passedImages = []
//                }
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
            return cell
        case .pastEvent:
            //TODO: past event
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsUpcomingEventTableViewCell.self)) as! PostsUpcomingEventTableViewCell
            return cell
        case .quiz:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsQuizTableViewCell.self)) as! PostsQuizTableViewCell
            return cell
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostImageTableViewCell.self)) as! PostImageTableViewCell
            cell.delegate = self
            cell.index = indexPath
            cell.post = posts[indexPath.row]
            tableView.beginUpdates()
            tableView.endUpdates()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
    }
    
    func didTapStartFromQuiz(at indexPath: IndexPath) {
        
    }
    
    func didPressLike(at index: IndexPath) {
        if UserCache.isLoggedIn{
            
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
