//
//  QuizQuestionCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/15/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class QuizQuestionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: QuizAnswerTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: QuizAnswerTableViewCell.self))
            tableView.separatorStyle = .none
        }
    }
    
    var selectedIndex: IndexPath!{
        willSet{
            if selectedIndex != nil{
                if let cell = tableView.cellForRow(at: selectedIndex) as? QuizAnswerTableViewCell{
                    cell.selectedView.backgroundColor = .white
                }
            }
        }
        didSet{
            if let cell = tableView.cellForRow(at: selectedIndex) as? QuizAnswerTableViewCell{
                cell.selectedView.backgroundColor = .mainOrange
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedIndex = IndexPath(row: 0, section: 0)
    }

}

extension QuizQuestionCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizAnswerTableViewCell.self)) as? QuizAnswerTableViewCell{
            cell.answerLabel.text = "Answer #\(indexPath.row + 1)"
            if indexPath == selectedIndex{
                cell.selectedView.backgroundColor = .mainOrange
            }
            else{
                cell.selectedView.backgroundColor = .white
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
