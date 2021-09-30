//
//  ViewShaow.swift
//  Caberz
//
//  Created by Ahmed Elesawy on 12/15/20.
//

import UIKit

class ViewShaow: UIView {
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 0.9
    }
}
