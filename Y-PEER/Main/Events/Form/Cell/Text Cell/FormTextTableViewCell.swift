//
//  FormTextTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

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
    
    var question: FormQuestionModel!{
        didSet{
            questionTitleLabel.text = question.text!
        }
    }
    var delegate: FormTextCellDelegate!
    var answerString: String!{
        didSet{
            if !answerTextView.isFirstResponder{
                if answerString == ""{
                    answerTextView.text = placeholderText
                    answerTextView.textColor = .lightGray
                }
                else{
                    answerTextView.textColor = .mainOrange
                    answerTextView.text = answerString
                }
            }
        }
    }
    var index: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
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
    
    func textViewDidChange(_ textView: UITextView) {
        answerString = textView.text
        delegate.didChangeText(textView.text, question, index)
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
    func didChangeText(_ text: String, _ question: FormQuestionModel, _ index: IndexPath)
}
