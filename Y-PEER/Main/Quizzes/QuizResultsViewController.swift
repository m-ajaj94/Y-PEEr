//
//  QuizResultsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Presentr

class QuizResultsViewController: ParentViewController {

    @IBOutlet weak var quizResultsLabel: UILabel!{
        didSet{
            quizResultsLabel.text = "Quiz results".localized
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: QuizResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: QuizResultTableViewCell.self))
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var scoreContainerView: UIView!{
        didSet{
            scoreContainerView.layer.shadowOffset = .zero
            scoreContainerView.layer.shadowColor = UIColor.black.cgColor
            scoreContainerView.layer.shadowRadius = 4
            scoreContainerView.layer.shadowOpacity = 0.3
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowOpacity = 0.3
        }
    }
    
    let presenter: Presentr = {
        let width = ModalSize.custom(size: Float(UIScreen.main.bounds.width * 0.8))
        let height = ModalSize.custom(size: Float(UIScreen.main.bounds.height * 0.5))
        let center = ModalCenterPosition.center//custom(centerPoint: CGPoint(x: view.center.x, y: view.center.y - 44))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 10
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.4
        return customPresenter
    }()
    var quizModel: QuizDetails!
    var userChoices: [Int:QuizQuestionOptionModelModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results".localized
        countLabel.text = "\(quizModel.questions!.count)"
        var sum = 0
        for question in quizModel.questions!{
            sum = sum + userChoices[question.id!]!.isTrue!
        }
        correctCountLabel.text = "\(sum)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scoreContainerView.layer.cornerRadius = scoreContainerView.frame.width / 2
    }

}

extension QuizResultsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizModel!.questions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizResultTableViewCell.self)) as! QuizResultTableViewCell
        let question = quizModel.questions![indexPath.row]
        for answer in quizModel.questions![indexPath.row].options!{
            if answer.isTrue! == 1{
                if answer.id! == userChoices[question.id!]!.id!{
                    cell.cellImageView.image = UIImage(named: "correct")
                }
                else{
                    cell.cellImageView.image = UIImage(named: "wrong")
                }
                break
            }
        }
        cell.cellLabel.text = "Question".localized + "#\(indexPath.row + 1)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: QuizPopupViewController.self)) as! QuizPopupViewController
        controller.question = quizModel.questions![indexPath.row]
        controller.answer = userChoices[quizModel.questions![indexPath.row].id!]!
        customPresentViewController(presenter, viewController: controller, animated: true)
    }
    
}
