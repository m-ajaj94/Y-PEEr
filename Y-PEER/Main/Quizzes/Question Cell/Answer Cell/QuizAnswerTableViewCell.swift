//
//  QuizAnswerTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/15/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class QuizAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedView: UIView!{
        didSet{
            selectedView.layer.borderColor = UIColor.mainOrange.cgColor
            selectedView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        if Cache.language.current == .arabic{
            self.flipX()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedView.layer.cornerRadius =  4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
