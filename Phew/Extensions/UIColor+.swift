//
//  UIColor+.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

extension UIColor {
    //NavColor
    static let NavColor: UIColor = UIColor.red//UIColor(named: "NavColor")!
    static let mainBlack: UIColor = UIColor(hex: "656262")
    static let mainWhite: UIColor = UIColor.red//UIColor(named: "White")!
    static let logoColor = UIColor.red//UIColor(named: "logoColor")!
    static let mainRed: UIColor = UIColor(hex: "E21E2C")
    
    static let mainColor: UIColor = mainRed
    static let LightGray: UIColor = UIColor.red//UIColor(named: "LightGray")!pl
    static let mainGreen: UIColor = UIColor(hex: "0CD245")
    static let backgroundCellColor: UIColor =  UIColor.red//UIColor(named: "backgroundCell")!
    static let backgroundColor: UIColor =  UIColor.red//UIColor(named: "backgroundColor")!
//    static let mainBackGroundColor: UIColor = #colorLiteral(red: 1, green: 0.9810138345, blue: 0.9432478547, alpha: 1)
//    static let mainYallow: UIColor = #colorLiteral(red: 0.9585794806, green: 0.792750895, blue: 0.2526831627, alpha: 1)
    
//    static let mainRed: UIColor = #colorLiteral(red: 0.9882352941, green: 0.1921568627, blue: 0.231372549, alpha: 1)
        //UIColor(red: 0.878, green: 0.169, blue: 0.153, alpha: 1)
    static let mainGray: UIColor = UIColor.black.withAlphaComponent(0.4)
//    static let mainLightGray: UIColor = UIColor.black.withAlphaComponent(0.2)
//    static let mainVeryLightGray: UIColor = UIColor.black.withAlphaComponent(0.1)
}

public extension UIColor {
    convenience init(hex: Int) {
        let components = (
                R: CGFloat((hex >> 16) & 0xff) / 255,
                G: CGFloat((hex >> 08) & 0xff) / 255,
                B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            fatalError("Color value not correct")
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(hex: Int(rgbValue))
    }
}

