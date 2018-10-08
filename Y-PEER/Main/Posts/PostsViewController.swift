//
//  PostsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SkeletonView

class PostsViewController: ParentViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            if tableView != nil{
                tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                tableView.isSkeletonable = true
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.rowHeight = UITableViewAutomaticDimension
                tableView.estimatedRowHeight = 260
                tableView.allowsSelection = false
                tableView.register(UINib(nibName: String(describing: PostsSkeletonTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsSkeletonTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostsQuizTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsQuizTableViewCell.self))
                tableView.register(UINib(nibName: String(describing: PostImageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostImageTableViewCell.self))
            }
        }
    }
    @IBOutlet weak var sidemenuButton: UIBarButtonItem!
    
    @IBAction func sideMenuButtonPressed(_ sender: UIBarButtonItem) {
        if let tabController = tabBarController as? MainTabBarController{
            tabController.showSideMenu()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.showAnimatedGradientSkeleton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.hideSkeleton(reloadDataAfter: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isSkeletonable = true
        tableView.hideSkeleton(reloadDataAfter: true)
    }

}

extension PostsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate, PostsQuizTableViewCellDelegate, PostImageTableViewCellDelegate{
    
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isSkeletonActive{
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsSkeletonTableViewCell.self)) as? PostsSkeletonTableViewCell{
                return cell
            }
        }
        else{
            let x = indexPath.row & 1
            if x == 0 || indexPath.row < 4{
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostImageTableViewCell.self)) as? PostImageTableViewCell{
                    cell.delegate = self
                    cell.index = indexPath
                    var array: [String] = []
                    for _ in 0...indexPath.row{
                        array.append("a.jpg")
                    }
                    cell.images = array
                    return cell
                }
            }
            else{
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsQuizTableViewCell.self)) as? PostsQuizTableViewCell{
                    cell.delegate = self
                    cell.index = indexPath
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func didTapStartFromQuiz(at indexPath: IndexPath) {
        
    }
    
    func didPressLike(at index: IndexPath) {
        
    }
    
    func didSeletImage(at index: IndexPath, from originalIndex: IndexPath) {
        
    }
    
}
