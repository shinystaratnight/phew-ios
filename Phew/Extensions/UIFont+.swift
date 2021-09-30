//
//  UIFont+.swift
//  Driver App
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func CairoLight(of size: CGFloat) -> UIFont {
        return UIFont(name: "Cairo-Light", size: size)!
    }
    
    static func CairoRegular(of size: CGFloat) -> UIFont {
        return UIFont(name: "Cairo-Regular", size: size)!
    }
    
    static func CairoSemiBold(of size: CGFloat) -> UIFont {
        return UIFont(name: "Cairo-SemiBold", size: size)!
    }
    
    static func CairoBold(of size: CGFloat) -> UIFont {
        return UIFont(name: "Cairo-Bold", size: size)!
    }
    
    static func tahomaRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Tahoma", size: size)!
    }
    
    static func tahomaBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Tahoma-Bold", size: size)!
    }
}

extension String {
func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.font = font
    label.sizeToFit()

    return label.frame.height
 }
}
