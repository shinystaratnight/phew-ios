//
//  ViewClass.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ViewClass: UIView {
    
    override init (frame: CGRect) {
         super.init(frame: frame)
         setup()
     }

     required init(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)!
         setup()
    }
    
    func setup () {
//        backgroundColor = .mainWhite
        viewCornerRadius = 6
        withShadow()
    }
}


