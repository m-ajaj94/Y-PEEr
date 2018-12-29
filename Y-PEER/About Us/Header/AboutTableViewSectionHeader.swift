//
//  AboutTableViewSectionHeader.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class AboutTableViewSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!{
        didSet{
            headerLabel.text = "About Y-PEER".localized
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

}
