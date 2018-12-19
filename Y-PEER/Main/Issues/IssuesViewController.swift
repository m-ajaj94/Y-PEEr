//
//  IssuesViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Toaster

class IssuesViewController: ParentViewController {
    
    private let showIssueSegueIdentifier = "ShowIssue"

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func meunButtonPressed(_ sender: Any) {
        if let tabController = tabBarController as? MainTabBarController{
            tabController.showSideMenu()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            if collectionView != nil{
                collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.register(UINib(nibName: String(describing: IssuesHeaderCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: IssuesHeaderCollectionReusableView.self))
                collectionView.register(UINib(nibName: String(describing: IssuesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: IssuesCollectionViewCell.self))
            }
        }
    }
    
    private let numberOfColoumns: CGFloat = 2
    var issues: [IssueModel]!{
        didSet{
            collectionView.reloadData()
        }
    }
    var selectedIndex: IndexPath!{
        didSet{
            performSegue(withIdentifier: showIssueSegueIdentifier, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Issues"
        requestData()
    }
    
    func requestData(){
        Networking.issues.getIssues { (model) in
            if model != nil{
                if model!.code == "1"{
                    self.issues = model!.data!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showIssueSegueIdentifier{
            let controller = segue.destination as! IssueViewController
            controller.issue = issues[selectedIndex.row]
        }
    }

}

extension IssuesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if issues != nil{
            return issues.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IssuesCollectionViewCell.self), for: indexPath) as? IssuesCollectionViewCell{
            cell.issue = issues[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: 60)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 32 - ((numberOfColoumns - 1) * 8)) / numberOfColoumns
        return CGSize(width: width, height: width + 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader{
//            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: IssuesHeaderCollectionReusableView.self), for: indexPath) as? IssuesHeaderCollectionReusableView{
//                header.headerLabel.text = "Header #\(indexPath.row + 1)"
//                return header
//            }
//        }
//        return UICollectionReusableView()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
}
