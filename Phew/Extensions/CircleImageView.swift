//
//  CircleImageView.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import MOLH

class CircleImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}


class FlipImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else{
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
