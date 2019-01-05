//
//  SerachViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/3/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class SearchViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource, ErrorViewDelegate {
    
    let titles = ["Events".localized, "Posts".localized, "Articles".localized, "Stories".localized]
    var viewControllers: [SearchResultsViewController]!
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let barItem = TMBarItem(title: titles[index])
        return barItem
    }
    

    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.setLeftPaddingPoints(44)
            searchTextField.setRightPaddingPoints(16)
            searchTextField.layer.cornerRadius = 0
            searchTextField.layer.borderWidth = 1
            searchTextField.layer.borderColor = UIColor.mainOrange.cgColor
            searchTextField.textColor = .mainOrange
            searchTextField.placeholder = "Search".localized
            searchTextField.keyboardType = .webSearch
            searchTextField.delegate = self
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var data: SearchModel!{
        didSet{
            reloadData()
        }
    }
    let pageSize = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search".localized
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.isUserInteractionEnabled = true
        self.view.insertSubview(backgroundImage, at: 0)
        hidesKeyboardOnTap()
        viewControllers = []
        for _ in 0..<4{
            let controller = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: String(describing: SearchResultsViewController.self)) as! SearchResultsViewController
            controller.topInset = tabBarView.frame.origin.y + tabBarView.frame.height
            viewControllers.append(controller)
        }
        self.dataSource = self
        self.delegate = self
        let bar = TMBar.TabBar()
        bar.delegate = self
        bar.backgroundView.style = .blur(style: .extraLight)
        bar.buttons.customize { (button) in
            button.backgroundColor = .white
            button.imageViewSize = .zero
            button.tintColor = UIColor.darkGray
            button.selectedTintColor = .mainOrange
        }
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        reloadData()
    }
    
    func requestData(){
        showLoading(below: searchTextField)
        Networking.search.search(["word":searchTextField.text!, "skip":0, "take":20, "user_id":UserCache.userID]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code! == "1"{
                    self.data = model!.data!
                }
                else{
                    self.showNoConnectionForSearch(below: self.searchTextField)
                }
            }
            else{
                self.showNoConnectionForSearch(below: self.searchTextField)
            }
        }
    }
    
    func didPressRetry() {
        removeNoConnectionForSearch()
        requestData()
    }
    
    func showNoConnectionForSearch(below tempView: UIView){
        let errorView = ErrorView.instanciateFromNib("No Connection".localized, "Please check your internet connection and press retry")
        errorView.tag = 1
        errorView.frame = CGRect(origin: .zero, size: view.frame.size)
        errorView.delegate = self
        view.insertSubview(errorView, belowSubview: tempView)
    }
    
    func removeNoConnectionForSearch(){
        view.viewWithTag(1)!.removeFromSuperview()
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 4
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let controller = viewControllers[index]
        controller.type = SearchResultType.init(rawValue:index + 1)
        controller.data = data
        controller.delegate = self
        controller.word = searchTextField.text!
        return controller
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}

extension SearchViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.empty{
            showAlert("Error".localized, "Please enter some text first".localized)
        }
        else{
            requestData()
        }
        return true
    }
    
}

extension SearchViewController: SearchResultsViewControllerDelegate{
    func didSelect(at index: IndexPath, with type: SearchResultType) {
        switch type {
        case .posts:
            let post = data.posts![index.row]
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: PostDetailsViewController.self)) as! PostDetailsViewController
            controller.post = post
            navigationController?.pushViewController(controller, animated: true)
            break
        case .events:
            let event = data.events![index.row]
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventDetailsViewController.self)) as! EventDetailsViewController
            controller.event = event
            controller.type = event.type! == "passed" ? PostType.pastEvent : PostType.event
            navigationController?.pushViewController(controller, animated: true)
            break
        case .articles:
            let article = data.articles![index.row]
            let controller = UIStoryboard(name: "Issue", bundle: nil).instantiateViewController(withIdentifier: String(describing: IssueArticleViewController.self)) as! IssueArticleViewController
            controller.article = article
            navigationController?.pushViewController(controller, animated: true)
            break
        case .stories:
            let story = data.stories![index.row]
            let controller = UIStoryboard(name: "Stories", bundle: nil).instantiateViewController(withIdentifier: String(describing: StoryDetailsViewController.self)) as! StoryDetailsViewController
            controller.story = story
            navigationController?.pushViewController(controller, animated: true)
            break
        }
    }
    func didUpdateData(data: [Any], type: SearchResultType) {
//        switch type {
//        case .posts:
//            let array = data as! [PostModel]
//            self.data.posts!.append(contentsOf: array)
//            break
//        case .events:
//            let array = data as! [EventDataModel]
//            self.data.events!.append(contentsOf: array)
//            break
//        case .articles:
//            let array = data as! [ArticleModel]
//            self.data.articles!.append(contentsOf: array)
//            break
//        case .stories:
//            let array = data as! [StoryModel]
//            self.data.stories!.append(contentsOf: array)
//            break
//        }
    }
}
