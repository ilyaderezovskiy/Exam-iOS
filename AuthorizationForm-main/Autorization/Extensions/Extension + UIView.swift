//
//  Extension + UIView.swift
//  AutorizationForm
//
//  Created by Ilya Derezovskiy on 26/5/23.
//  


import UIKit

extension UIView {
    func addVerticalGradienLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.blue.cgColor
        ]
        

        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradientLayer, at: 2)
//        layer.addSublayer(gradientLayer)
    }
}
