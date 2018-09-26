//
//  SettingsViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class SettingsViewController: ParentViewController {
    
    private let aboutSegueIdentifier = "ShowAbout"

    @IBOutlet weak var doneButtoon: UIBarButtonItem!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings".localized
    }

}
