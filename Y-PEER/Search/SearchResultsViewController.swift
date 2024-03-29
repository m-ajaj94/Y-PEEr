//
//  SearchResultsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/3/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import UIKit

class SearchResultsViewController: ParentViewController {
    
    var heights: [IndexPath:CGFloat] = [:]
    
    var topInset: CGFloat!

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: String(describing: SearchResultsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SearchResultsTableViewCell.self))
        }
    }
    
    @IBOutlet weak var emptyLabel: UILabel!{
        didSet{
            emptyLabel.text = "Search for something".localized
        }
    }
    @IBOutlet weak var emptyContainerView: UIView!{
        didSet{
            emptyContainerView.layer.cornerRadius = 4
            emptyContainerView.layer.borderWidth = 1
            emptyContainerView.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    var type: SearchResultType!
    var data: SearchModel!{
        didSet{
            if emptyLabel != nil && emptyContainerView != nil{
                switch type!{
                case .posts:
                    emptyLabel.isHidden = data != nil && data.posts!.count != 0
                    emptyContainerView.isHidden = data != nil && data.posts!.count != 0
                    break
                case .events:
                    emptyLabel.isHidden = data != nil && data.events!.count != 0
                    emptyContainerView.isHidden = data != nil && data.events!.count != 0
                    break
                case .articles:
                    emptyLabel.isHidden = data != nil && data.articles!.count != 0
                    emptyContainerView.isHidden = data != nil && data.articles!.count != 0
                    break
                case .stories:
                    emptyLabel.isHidden = data != nil && data.stories!.count != 0
                    emptyContainerView.isHidden = data != nil && data.stories!.count != 0
                    break
                }
            }
            if tableView != nil{
                tableView.reloadData()
            }
        }
    }
    var delegate: SearchResultsViewControllerDelegate!
    var word: String!{
        didSet{
            if emptyLabel != nil && word != ""{
                emptyLabel.text = "No Data Found".localized
            }
        }
    }
    let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if word != ""{
            emptyLabel.text = "No Data Found".localized
        }
        if #available(iOS 11.0, *) {
            let bottomSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomSafeArea, right: 0)
        }
        else{
            tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        tableView.addInfiniteScroll { (tableView) in
            if self.word != nil && self.word != ""{
                self.requestMore()
            }
            else{
                tableView.finishInfiniteScroll()
            }
        }
        switch type!{
        case .posts:
            emptyLabel.isHidden = data != nil && data.posts!.count != 0
            emptyContainerView.isHidden = data != nil && data.posts!.count != 0
            break
        case .events:
            emptyLabel.isHidden = data != nil && data.events!.count != 0
            emptyContainerView.isHidden = data != nil && data.events!.count != 0
            break
        case .articles:
            emptyLabel.isHidden = data != nil && data.articles!.count != 0
            emptyContainerView.isHidden = data != nil && data.articles!.count != 0
            break
        case .stories:
            emptyLabel.isHidden = data != nil && data.stories!.count != 0
            emptyContainerView.isHidden = data != nil && data.stories!.count != 0
            break
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if #available(iOS 11.0, *) {
                let bottomSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
                self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: max(UIScreen.main.bounds.height - endFrame!.origin.y, bottomSafeArea), right: 0)
            }
            else{
                self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: max(UIScreen.main.bounds.height - endFrame!.origin.y, 0), right: 0)
            }
        }
    }
    
    func requestMore(){
        switch type! {
        case .articles:
            let dict: [String:Any] = ["word":word, "skip":data.articles!.count, "take":pageSize, "user_id":UserCache.userID, "factor": type.rawValue]
            Networking.search.pageArticles(dict) { (model) in
                self.tableView.finishInfiniteScroll()
                if model != nil && model!.code! == "1"{
                    self.data.articles!.append(contentsOf: model!.data!)
                    self.tableView.reloadData()
                    self.delegate.didUpdateData(data: model!.data!, type: self.type)
                }
            }
            break
        case .events:
            let dict: [String:Any] = ["word":word, "skip":data.events!.count, "take":pageSize, "user_id":UserCache.userID, "factor": type.rawValue]
            Networking.search.pageEvents(dict) { (model) in
                self.tableView.finishInfiniteScroll()
                if model != nil && model!.code! == "1"{
                    self.data.events!.append(contentsOf: model!.data!)
                    self.tableView.reloadData()
                    self.delegate.didUpdateData(data: model!.data!, type: self.type)
                }
            }
            break
        case .posts:
            let dict: [String:Any] = ["word":word, "skip":data.posts!.count, "take":pageSize, "user_id":UserCache.userID, "factor": type.rawValue]
            Networking.search.pagePosts(dict) { (model) in
                self.tableView.finishInfiniteScroll()
                if model != nil && model!.code! == "1"{
                    self.data.posts!.append(contentsOf: model!.data!)
                    self.tableView.reloadData()
                    self.delegate.didUpdateData(data: model!.data!, type: self.type)
                }
            }
            break
        case .stories:
            let dict: [String:Any] = ["word":word, "skip":data.stories!.count, "take":pageSize, "user_id":UserCache.userID, "factor": type.rawValue]
            Networking.search.pageStories(dict) { (model) in
                self.tableView.finishInfiniteScroll()
                if model != nil && model!.code! == "1"{
                    self.data.stories!.append(contentsOf: model!.data!)
                    self.tableView.reloadData()
                    self.delegate.didUpdateData(data: model!.data!, type: self.type)
                }
            }
            break
        }
    }

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data == nil{
            return 0
        }
        switch type!{
        case .posts:
            return data!.posts!.count
        case .events:
            return data!.events!.count
        case .articles:
            return data!.articles!.count
        case .stories:
            return data!.stories!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self)) as! SearchResultsTableViewCell
        switch type!{
        case .posts:
            cell.titleLabel.text = data.posts![indexPath.row].title
            cell.descriptionLabel.text = data.posts![indexPath.row].description
            break
        case .events:
            cell.titleLabel.text = data.events![indexPath.row].title
            cell.descriptionLabel.text = data.events![indexPath.row].description
            break
        case .articles:
            let article = data.articles![indexPath.row]
            if Cache.language.current == .english{
                cell.titleLabel.text = article.titleEn
                cell.descriptionLabel.text = article.descriptionEn
            }
            else{
                cell.titleLabel.text = article.titleAr
                cell.descriptionLabel.text = article.descriptionAr
            }
            break
        case .stories:
            let story = data.stories![indexPath.row]
            if story.nameVisibility! == 1{
                cell.titleLabel.text = data.stories![indexPath.row].username!.name!
            }
            else{
                cell.titleLabel.text = "Anonymous".localized
            }
            cell.descriptionLabel.text = story.story!
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.didSelect(at: indexPath, with: type)
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

enum SearchResultType:Int{
    case events = 1
    case posts = 2
    case articles = 3
    case stories = 4
}

protocol SearchResultsViewControllerDelegate {
    func didSelect(at index: IndexPath, with type: SearchResultType)
    func didUpdateData(data: [Any], type: SearchResultType)
}
