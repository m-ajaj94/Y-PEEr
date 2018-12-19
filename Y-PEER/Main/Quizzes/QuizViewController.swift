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
        }
    }
    @IBOutlet weak var prevButton: UIButton!{
        didSet{
            prevButton.setTitleColor(.white, for: .normal)
            prevButton.backgroundColor = .gray
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = .mainOrange
        }
    }
    
    @IBAction func prevButtonPresed(_ sender: Any) {
        if currentIndex != 0{
            currentIndex = currentIndex - 1
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        if currentIndex != 4{
            currentIndex = currentIndex + 1
        }
    }
    
    var currentIndex: Int{
        get{
            return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        }
        set{
            collectionView.setContentOffset(CGPoint(x: CGFloat(newValue) * collectionView.frame.size.width, y: collectionView.contentOffset.y), animated: true)
            prevButton.isEnabled = newValue != 0
            nextButton.isEnabled = newValue != 4
            if newValue == 4{
                nextButton.setTitle("Get Results", for: .normal)
            }
            else{
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prevButton.layer.cornerRadius = prevButton.frame.size.height / 2
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
    }

}

extension QuizViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: QuizQuestionCollectionViewCell.self), for: indexPath) as? QuizQuestionCollectionViewCell{
            cell.questionLabel.text = "Quiz Question number #\(indexPath.row + 1)\nWould you please select an answer?"
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
