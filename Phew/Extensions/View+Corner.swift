//
//  View+Corner.swift
//  Stylcom
//
//  Created by Ahmed Elesawy on 10/21/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func cornerRadiusViewChat() {
        viewCornerRadius = 15
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        applySketchShadow()
        viewBorderColor = .clear
        viewBorderWidth = 0.4
    }
    
    func cornerRadiusViewChatAnother() {
        viewCornerRadius = 15
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        applySketchShadow()
        viewBorderColor = .clear
        viewBorderWidth = 0.4
    }
}


extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
