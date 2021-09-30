//
//  UIimageView+.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func load(with url: String?, cop: ((_ image: UIImage?) -> Void)? = nil) {
        let placeHolder = UIImage()
        image = placeHolder
        
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        
        let ind = UIActivityIndicatorView(style: .gray)
        addSubview(ind)
        ind.centerInSuperview()
        ind.startAnimating()
        ind.color = .mainColor
        ind.isHidden = false
        let options: SDWebImageOptions = [.continueInBackground]
        sd_setImage(with: url, placeholderImage: placeHolder, options: options, progress: nil) {[weak self] (image, error, cache, url) in
            ind.removeFromSuperview()
            if image == nil {
                self?.image = placeHolder
                cop?(nil)
            } else {
                self?.image = image
                cop?(image)
            }
        }
    }
}

extension UIButton {
    func load(with url: String?, cop: ((_ image: UIImage?) -> Void)? = nil) {
        let placeHolder = UIImage()
        setBackgroundImage(placeHolder, for: .normal)
        
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        
        let ind = UIActivityIndicatorView(style: .gray)
        addSubview(ind)
        ind.center = self.center
        ind.startAnimating()
        ind.color = .mainColor
        ind.isHidden = false
        
        sd_setImage(with: url, for: .normal) {[weak self] (image, error, cache, url) in
            ind.removeFromSuperview()
            if image == nil {
                self?.setBackgroundImage(placeHolder, for: .normal)
                cop?(nil)
            } else {
                self?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                cop?(image)
            }
        }
    }
}

extension UIImageView {
    func rotateImage180(){
        
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
}
