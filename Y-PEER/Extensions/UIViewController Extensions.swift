//
//  UIViewController Extensions.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 10/9/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import Lightbox
import Toaster

extension UIViewController{
    
    func hidesKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showImages(_ images: [ImageModel], _ index: Int){
        var array: [LightboxImage] = []
        for image in images{
            array.append(LightboxImage(imageURL: Networking.getImageURL(image.imagePath!)))
        }
        let controller = LightboxController(images: array)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
        controller.goTo(index)
    }
    
    func showErrorAlert(_ message: String){
        let alert = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        alert.view.tintColor = .mainOrange
        let okayAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .mainOrange
        let okayAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController{
    
    func showNoConnection(){
        let errorView = ErrorView.instanciateFromNib("No Connection".localized, "Please check your internet connection and press retry")
        errorView.tag = 1
        errorView.frame = CGRect(origin: .zero, size: view.frame.size)
        if let controller = self as? ParentViewController{
            errorView.delegate = controller
        }
        view.addSubview(errorView)
    }
    
    func showNoConnection(below tempView: UIView){
        let errorView = ErrorView.instanciateFromNib("No Connection".localized, "Please check your internet connection and press retry")
        errorView.tag = 1
        errorView.frame = CGRect(origin: .zero, size: view.frame.size)
        if let controller = self as? ParentViewController{
            errorView.delegate = controller
        }
        view.insertSubview(errorView, belowSubview: tempView)
    }
    
    func removeNoConnection(){
        view.viewWithTag(1)!.removeFromSuperview()
    }
    
    func showLoading(){
        let loadingView = LoadingView.instanciateFromNib()
        loadingView.indicator.startAnimating()
        loadingView.label.text = "Loading...".localized
        loadingView.tag = 2
        loadingView.frame = CGRect(origin: .zero, size: view.frame.size)
        view.addSubview(loadingView)
    }
    
    func removeLoading(){
        view.viewWithTag(2)!.removeFromSuperview()
    }
    
}

extension UIView {
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
}
