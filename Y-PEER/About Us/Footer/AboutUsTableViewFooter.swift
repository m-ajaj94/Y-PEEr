//
//  AboutUsTableViewFooter.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class AboutUsTableViewFooter: UITableViewHeaderFooterView {

    @IBAction func buttonPressed(_ sender: Any) {
        delegate.didPressButton()
    }
    
    var delegate: AboutUsTableViewFooterDelegate!
    
    static func instanciateFromNib() -> AboutUsTableViewFooter{
        return Bundle.main.loadNibNamed(String(describing: AboutUsTableViewFooter.self), owner: self, options: nil)![0] as! AboutUsTableViewFooter
    }

}

protocol AboutUsTableViewFooterDelegate{
    func didPressButton()
}
