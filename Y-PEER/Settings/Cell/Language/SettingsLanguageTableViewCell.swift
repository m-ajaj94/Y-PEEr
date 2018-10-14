//
//  SettingsLanguageTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SettingsLanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView!{
        didSet{
            innerView.backgroundColor = .mainOrange
        }
    }
    @IBOutlet weak var outerView: UIView!{
        didSet{
            outerView.backgroundColor = .white
            outerView.layer.borderWidth = 1
            outerView.layer.borderColor = UIColor.mainOrange.cgColor
        }
    }
    @IBOutlet weak var cellLabel: UILabel!
    
    var isRadioSelected: Bool!{
        didSet{
            innerView.isHidden = !isRadioSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outerView.layer.cornerRadius = outerView.frame.size.width / 2
        innerView.layer.cornerRadius = innerView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
