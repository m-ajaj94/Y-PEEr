//
//  UIViewController Extensions.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/9/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Lightbox

extension UIViewController{
    
    func hidesKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showImages(_ images: [String], _ index: Int){
        var array: [LightboxImage] = []
        for image in images{
            array.append(LightboxImage(image: UIImage(named: image)!, text: "Some text about image #\(index)", videoURL: nil))
        }
        let controller = LightboxController(images: array)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
        controller.goTo(index)
    }
    
    func showErrorAlert(_ message: String){
        let alert = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        alert.view.tintColor = .mainOrange
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}
