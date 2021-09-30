//
//  BaseView.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol BaseViewProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func showAlert(with message: String?)
}

extension BaseViewProtocol where Self: UIViewController {
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        startLoading()
    }
    
    func stopLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        stopLoading()
    }
    
    func showAlert(with message: String?) {
        if let x =  message , x != "" {
            showAlert(message: message)
        }
    }
}
