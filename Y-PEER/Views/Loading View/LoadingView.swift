//
//  LoadingView.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/25/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {

    @IBOutlet weak var gradientView: RadialGradientView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    static func instanciateFromNib() -> LoadingView{
        let view =  Bundle.main.loadNibNamed(String(describing: LoadingView.self), owner: self, options: nil)![0] as! LoadingView
        if Cache.language.current == .arabic{
            view.indicator.flipX()
        }
        return view
    }
    
}

@IBDesignable class RadialGradientView: UIView {
    
    @IBInspectable var outsideColor: UIColor = UIColor.red
    @IBInspectable var insideColor: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
}
