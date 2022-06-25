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
extension UILabel{
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0,font : UIFont = UIFont.SFProTextBold17) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font,  value: /*UIFont(name: "NeoSansArabic", size: 18)!*/font, range:NSMakeRange(0, attributedString.length))

        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
extension UIFont {

    enum Font: String {
        case SFProTextBold = "SFProText-Bold"

        var name: String {
            return self.rawValue
        }
    }
    class var SFProTextBold17: UIFont {
        return UIFont(name: Font.SFProTextBold.rawValue, size: 17)!
    }
}
