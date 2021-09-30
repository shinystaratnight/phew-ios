//
//  UIButton +.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class CustomRadioButton: UIButton {
    
    override func awakeFromNib() {
        buttonSetting()
    }
    
    func buttonSetting() {
        CircleButton.circle(btn: self)
        backgroundColor  = .mainWhite
        viewBorderColor  = .mainBlack
        viewBorderWidth  = 1.4
    }
}

class CircleButton {
    class func circle(btn : UIButton) {
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = btn.frame.size.width / 2
        btn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.clipsToBounds = true
    }
}
