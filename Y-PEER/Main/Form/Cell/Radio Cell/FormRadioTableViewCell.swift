//
//  FormRadioTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/2/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import UIKit

class FormRadioTableViewCell: UITableViewCell {
    
    var heights: [IndexPath:CGFloat] = [:]

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: String(describing: SettingsLanguageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingsLanguageTableViewCell.self))
        }
    }
    @IBOutlet weak var questionLabel: UILabel!
    
    var delegate: FormRadioTableViewCellDelegate!
    var selectedOption: FormOptionModel!
    var question: FormQuestionModel!{
        didSet{
            questionLabel.text = question.text
            tableView.reloadData()
            heightConstraint.constant = tableView.contentSize.height + 16
            layoutSubviews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}

extension FormRadioTableViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsLanguageTableViewCell.self)) as! SettingsLanguageTableViewCell
        cell.cellLabel.text = question.options![indexPath.row].text!
        cell.isRadioSelected = question.options![indexPath.row].id! == selectedOption.id!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedOption = question.options![indexPath.row]
        tableView.reloadData()
        delegate.didSelect(question.options![indexPath.row], question)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heights[indexPath] = cell.bounds.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.heights[indexPath] {
            return height
        }
        return UITableView.automaticDimension
    }
    
}

protocol FormRadioTableViewCellDelegate {
    func didSelect(_ answer: FormOptionModel, _ question: FormQuestionModel)
}
