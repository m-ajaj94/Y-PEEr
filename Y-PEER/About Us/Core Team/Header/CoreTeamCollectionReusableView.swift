//
//  CoreTeamCollectionReusableView.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/24/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class CoreTeamCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var label: UILabel!{
        didSet{
            label.text = "Core Team".localized
        }
    }
    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var backgroundHalfView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circularView.layer.cornerRadius = circularView.frame.size.width / 2
    }
    
}
