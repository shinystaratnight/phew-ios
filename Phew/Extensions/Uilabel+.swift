//
//  Lable+.swift
//  AMNUH-Driver
//
//  Created by Ahmed Elesawy on 1/19/20.
//  Copyright © 2020 Ahmed Elesawy. All rights reserved.
//

import Foundation
import UIKit
extension UILabel{
   
    convenience init(text:String, font:UIFont,textColor: UIColor){
        self.init(frame:.zero)
        self.font = font
        self.text = text
        self.textColor  = textColor
        
    }
    var  textCenter:UILabel {
       textAlignment = .center
        return self
    }
    var lineZero :UILabel {
        numberOfLines = 0
        return self
    }
    
    var centerZero:UILabel {
         textAlignment = .center
        numberOfLines = 0
        return self
    }
    
}
