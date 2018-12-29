//
//  QuizQuestionCollectionViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/15/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class QuizQuestionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var questionLabel: UILabel!{
        didSet{
            if Cache.language.current == .arabic{
                questionLabel.flipX()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: QuizAnswerTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: QuizAnswerTableViewCell.self))
            tableView.separatorStyle = .none
        }
    }
    
    var question: QuizQuestionModel!{
        didSet{
            questionLabel.text = question.description!
            tableView.reloadData()
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
    var delegate: QuizDelegate!
    
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
        if question != nil{
            return question.options!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.didAnswer(question, question.options![indexPath.row])
        selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizAnswerTableViewCell.self)) as? QuizAnswerTableViewCell{
            cell.answerLabel.text = question.options![indexPath.row].description!
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

protocol QuizDelegate{
    func didAnswer(_ question: QuizQuestionModel, _ answer: QuizQuestionOptionModelModel)
}
