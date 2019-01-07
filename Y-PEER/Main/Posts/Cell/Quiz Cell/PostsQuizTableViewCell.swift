//
//  PostsQuizTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/8/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class PostsQuizTableViewCell: UITableViewCell {

    @IBOutlet weak var startButton: UIButton!{
        didSet{
            startButton.setTitle("Start".localized, for: .normal)
        }
    }
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!{
        didSet{
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowRadius = 3
            shadowView.layer.shadowOpacity = 0.2
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        delegate.didTapStartFromQuiz(at: index)
    }
    
    var delegate: PostsQuizTableViewCellDelegate!
    var index: IndexPath!
    var quiz: QuizModel!{
        didSet{
            mainLabel.text = quiz.title!
            secondaryLabel.text = "\(quiz.questionsCount!) " + "Questions".localized
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonContainerView.layer.cornerRadius = buttonContainerView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

protocol PostsQuizTableViewCellDelegate {
    func didTapStartFromQuiz(at indexPath: IndexPath)
}
