//
//  QuizViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/15/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class QuizViewController: ParentViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.isScrollEnabled = false
            collectionView.register(UINib(nibName: String(describing: QuizQuestionCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: QuizQuestionCollectionViewCell.self))
            if Cache.language.current == .arabic{
                collectionView.flipX()
            }
        }
    }
    @IBOutlet weak var prevButton: UIButton!{
        didSet{
            prevButton.setTitleColor(.white, for: .normal)
            prevButton.backgroundColor = .gray
            prevButton.setTitle("Previous".localized, for: .normal)
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = .mainOrange
            nextButton.setTitle("Next".localized, for: .normal)
        }
    }
    
    @IBAction func prevButtonPresed(_ sender: Any) {
//        if Cache.language.current == .arabic{
//            if currentIndex != quiz.questions!.count - 1{
//                currentIndex = currentIndex + 1
//            }
//        }
        if currentIndex != 0{
            currentIndex = currentIndex - 1
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
//        if Cache.language.current == .arabic{
//            if currentIndex != 0{
//                currentIndex = currentIndex - 1
//            }
//            else{
//                performSegue(withIdentifier: "ShowResults", sender: self)
//            }
//        }
//        else{
//        }
        
        if currentIndex != quiz.questions!.count - 1{
            currentIndex = currentIndex + 1
        }
        else{
            performSegue(withIdentifier: "ShowResults", sender: self)
        }
    }
    
    var userChoices: [Int:QuizQuestionOptionModelModel]! = [:]
    var currentIndex: Int{
        get{
            return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        }
        set{
            collectionView.setContentOffset(CGPoint(x: CGFloat(newValue) * collectionView.frame.size.width, y: collectionView.contentOffset.y), animated: true)
//            if Cache.language.current == .arabic{
////                prevButton.isEnabled = newValue != quiz.questions!.count - 1
////                nextButton.isEnabled = newValue != 0
//                if newValue == 0{
//                    nextButton.setTitle("Get Results".localized, for: .normal)
//                }
//                else{
//                    nextButton.setTitle("Next".localized, for: .normal)
//                }
//            }
//            else{
////                prevButton.isEnabled = newValue != 0
////                nextButton.isEnabled = newValue != quiz.questions!.count - 1
//                
//            }
            if newValue == quiz.questions!.count - 1{
                nextButton.setTitle("Get Results".localized, for: .normal)
            }
            else{
                nextButton.setTitle("Next".localized, for: .normal)
            }
        }
    }
    var quizID: Int!
    var quiz: QuizDetails!{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }
    
    @objc override func didPressRetry() {
        removeNoConnection()
        requestData()
    }
    
    func requestData(){
        showLoading()
        Networking.quiz.getQuiz(["quiz_id":quizID]) { (model) in
            self.removeLoading()
            if model != nil{
                if model!.code! == "1"{
                    self.quiz = model!.data!
                }
                else{
                    
                }
            }
            else{
                self.showNoConnection()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prevButton.layer.cornerRadius = prevButton.frame.size.height / 2
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults"{
            let controller = segue.destination as! QuizResultsViewController
            controller.quizModel = quiz!
            controller.userChoices = userChoices
        }
    }

}

extension QuizViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if quiz != nil{
            return quiz.questions!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: QuizQuestionCollectionViewCell.self), for: indexPath) as? QuizQuestionCollectionViewCell{
            cell.question = quiz.questions![indexPath.row]
            var question = quiz.questions![indexPath.row]
            if Cache.language.current == .arabic{
                question = quiz.questions![quiz.questions!.count - 1 - indexPath.row]
            }
            for i in 0..<question.options!.count{
                let answer = question.options![i]
                if userChoices[question.id!] == nil{
                    userChoices[question.id!] = question.options![0]
                }
                if answer.id! == userChoices[question.id!]!.id!{
                    cell.selectedIndex = IndexPath(row:i, section: 0)
                }
            }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension QuizViewController: QuizDelegate{
    func didAnswer(_ question: QuizQuestionModel, _ answer: QuizQuestionOptionModelModel) {
        userChoices[question.id!] = answer
    }
}
