//
//  FormTextTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class QuestionMM{
    
}

class FormTextTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!{
        didSet{
            answerTextView.layer.borderWidth = 0.5
            answerTextView.layer.borderColor = UIColor.mainOrange.cgColor
            answerTextView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            answerTextView.layer.cornerRadius = 10
            answerTextView.clipsToBounds = true
            answerTextView.text = placeholderText
            answerTextView.textColor = .lightGray
            answerTextView.delegate = self
        }
    }
    var placeholderText: String! = "Answer".localized + "..."
    
    var question: QuestionMM!
    
    var answerString: String!{
        didSet{
            if answerString == ""{
                answerTextView.text = placeholderText
                answerTextView.textColor = .lightGray
            }
            else{
                answerTextView.textColor = .mainOrange
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension FormTextTableViewCell: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == placeholderText && textView.textColor == .lightGray){
            textView.text = ""
            textView.textColor = .mainOrange
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

protocol FormTextCellDelegate{
    func didChangeText(_ text: String, _ question: QuestionMM)
}
