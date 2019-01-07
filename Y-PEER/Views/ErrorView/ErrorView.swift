//
//  ErrorView.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!{
        didSet{
            buttonContainerView.layer.cornerRadius = 4
            buttonContainerView.layer.borderColor = UIColor.white.cgColor
            buttonContainerView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var button: UIButton!{
        didSet{
            button.setTitle("Retry".localized, for: .normal)
        }
    }
    
    var delegate: ErrorViewDelegate!
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate.didPressRetry()
    }
    
    static func instanciateFromNib(_ title: String, _ description: String) -> ErrorView{
        let view = Bundle.main.loadNibNamed(String(describing: ErrorView.self), owner: self, options: nil)![0] as! ErrorView
        view.titleLabel.text = title
        view.descriptionLabel.text = description
        return view
    }

}

protocol ErrorViewDelegate{
    func didPressRetry()
}
