//
//  BorderTextField.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

extension UIView {
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = #colorLiteral(red: 0.2, green: 0, blue: 0, alpha: 0.19)
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
}
