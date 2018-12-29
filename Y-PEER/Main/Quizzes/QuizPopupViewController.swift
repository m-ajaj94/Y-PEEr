//
//  QuizPopupViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class QuizPopupViewController: ParentViewController {

    @IBOutlet weak var correctImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userAnswerTitleLabel: UILabel!{
        didSet{
            userAnswerTitleLabel.text = "Your Answer".localized
        }
    }
    @IBOutlet weak var userAnswerLabel: UILabel!
    @IBOutlet weak var answerTitleLabel: UILabel!{
        didSet{
            answerTitleLabel.text = "Correct Answer".localized
        }
    }
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var reasonTitleLabel: UILabel!{
        didSet{
            reasonTitleLabel.text = "Explanation".localized
        }
    }
    @IBOutlet weak var reasonLabel: UILabel!
    
    var question: QuizQuestionModel!
    var answer: QuizQuestionOptionModelModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question.description!
        for tempAnswer in question.options!{
            if tempAnswer.isTrue! == 1{
                answerLabel.text = tempAnswer.description!
                break
            }
        }
        if answer.isTrue! != 1{
            correctImageView.image = UIImage(named: "wrong")
        }
        userAnswerLabel.text = answer.description!
        reasonLabel.text = question.hint!
    }

}
