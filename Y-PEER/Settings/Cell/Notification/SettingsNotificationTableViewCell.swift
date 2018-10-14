//
//  SettingsNotificationTableViewCell.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/11/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SettingsNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBAction func didToggle(_ sender: Any) {
        delegate.didToggle(at: index, with: toggle.isOn)
    }
    
    var delegate: SettingsNotificationTableViewCellDelegate!
    var index: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

protocol SettingsNotificationTableViewCellDelegate {
    func didToggle(at indexPath: IndexPath, with state: Bool)
}
