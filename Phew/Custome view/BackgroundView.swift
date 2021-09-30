//
//  BackgroundView.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/27/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class BackgroundViewColor: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundColor
    }
}

class BackgroundBouttonColor: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .mainColor
        self.setTitleColor(.white, for: .normal)
    }
}

