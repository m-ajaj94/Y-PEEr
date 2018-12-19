//
//  QuizzesViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/14/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SkeletonView

class QuizzesViewController: ParentViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            if tableView != nil{
                tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                tableView.isSkeletonable = true
                tableView.delegate = self
                tableView.dataSource = self
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
    
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: "ShowQuiz", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes"
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostsQuizTableViewCell.self)) as? PostsQuizTableViewCell{
                cell.delegate = self
                cell.index = indexPath
                return cell
            }
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
    
    
}
