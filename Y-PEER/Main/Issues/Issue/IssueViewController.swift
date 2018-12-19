//
//  IssueViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class IssueViewController: ParentViewController {
    
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
        }
    }
    
    var images: [String] = []
    var issue: IssueModel!
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: showArticleSegueIdentifier, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = issue.title!
        detailsLabel.text = issue.description!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showArticleSegueIdentifier{
            let controller = segue.destination as! IssueArticleViewController
        }
    }

}

extension IssueViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IssueTableViewCell.self)) as? IssueTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
    }
    
}