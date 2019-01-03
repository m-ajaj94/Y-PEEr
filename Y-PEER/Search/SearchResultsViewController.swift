//
//  SearchResultsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/3/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import UIKit

class SearchResultsViewController: ParentViewController {
    
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
            emptyLabel.text = "No Data Found".localized
        }
    }
    @IBOutlet weak var emptyContainerView: UIView!{
        didSet{
            emptyContainerView.layer.cornerRadius = 4
            emptyContainerView.layer.borderWidth = 1
            emptyContainerView.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    
    var data: [String]!{
        didSet{
            emptyLabel.isHidden = data != nil && data.count != 0
            emptyContainerView.isHidden = data != nil && data.count != 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            let bottomSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomSafeArea, right: 0)
        }
        else{
            tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arc4random().quotientAndRemainder(dividingBy: 2).remainder == 1{
            emptyContainerView.isHidden = true
            emptyLabel.isHidden = true
            return 20
        }
        emptyContainerView.isHidden = false
        emptyLabel.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self)) as! SearchResultsTableViewCell
        return cell
    }
    
}
