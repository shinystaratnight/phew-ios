//
//  ActivityController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func startLoading() {
        let size = CGSize(width: 50, height: 50)
        NVActivityIndicatorView.DEFAULT_COLOR = #colorLiteral(red: 0.4156862745, green: 0.7411764706, blue: 0.4980392157, alpha: 1)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        startAnimating(size, message: "", type: NVActivityIndicatorType.ballClipRotate )
    }
    
    func stopLoading() {
//        stopAnimating()
    }
}
