//
//  UIImage+.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

extension UIImage {
    var template: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
    
    var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}

extension UIImage {
    func resizedImage(size: CGSize) -> UIImage? {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}
