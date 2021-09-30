//
//  CustomRedButton.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

public class CustomRedButton : UIButton {

    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.layer.borderWidth = 1
        self.backgroundColor = .mainColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont.CairoBold(of: 17)
 
    }
}

//public class CustomBlueButton : UIButton {
//
//    required public init?(coder aDecoder: NSCoder) {
//
//        super.init(coder: aDecoder)
//
//        self.layer.borderWidth = 1
//        self.backgroundColor = .mainColor
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 17
//        let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.setTitleColor(color, for: .normal)
//        self.titleLabel?.font = UIFont.CairoBold(of: 17)
//
//    }
//}
