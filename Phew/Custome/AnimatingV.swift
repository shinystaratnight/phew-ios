//
//  File.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/27/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit

class AnimatingV:UIView {
    
    private  let anim = CABasicAnimation(keyPath: "locations")
    private var _layer: CAGradientLayer?
    
    func animate(time: Float) {
        _layer = CAGradientLayer()
        guard let _layer = _layer else { return }
        let startLocations = [0, 0]
        let endLocations = [1, 2]
        _layer.colors = [UIColor.red.cgColor, UIColor.white.cgColor]
        #if DEBUG
        print(self.bounds.origin.x)
        #endif
        self.clipsToBounds = true
        _layer.frame = self.bounds
        _layer.locations = startLocations as [NSNumber]
        _layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        _layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(_layer)
        anim.fromValue = startLocations
        anim.toValue = endLocations
        anim.duration = CFTimeInterval(time)
        _layer.add(anim, forKey: "loc")
        _layer.locations = endLocations as [NSNumber]
    }
    
    func stopAnimation() {
        _layer?.removeFromSuperlayer()
        _layer?.removeAllAnimations()
        _layer = nil
        //        self.backgroundColor = #colorLiteral(red: 1, green: 0.9810138345, blue: 0.9432478547, alpha: 1)
    }
}
