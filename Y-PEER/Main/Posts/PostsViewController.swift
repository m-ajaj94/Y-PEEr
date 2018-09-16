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
                tableView.isSkeletonable = true
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.register(UINib(nibName: String(describing: PostsSkeletonTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostsSkeletonTableViewCell.self))
                tableView.rowHeight = UITableViewAutomaticDimension
                tableView.estimatedRowHeight = 260
                tableView.allowsSelection = false
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
        view.showAnimatedGradientSkeleton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.hideSkeleton(reloadDataAfter: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isSkeletonable = true
    }

}

extension PostsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: PostsSkeletonTableViewCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsSkeletonTableViewCell.self)) as? PostsSkeletonTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
    
}
