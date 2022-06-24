//
//  Extensions.swift
//  WeatherApp
//
//  Created by Nour_Madar on 23/06/2022.
//

import Foundation
import UIKit
extension UITableView{
    func setGradientBackground(topColor : UIColor,bottomColor : UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        let backgroundView = UIView(frame: self.bounds)
       
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)

        self.backgroundView = backgroundView
    }
}
@objc
 extension UIView{
   @objc func setViewGradientBackground(topColor : UIColor,bottomColor : UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)



        self.layer.insertSublayer(gradientLayer, at: 0)


    }
}
