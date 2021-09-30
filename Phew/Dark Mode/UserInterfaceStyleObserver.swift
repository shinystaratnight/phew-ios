//
//  UserInterfaceStyleObserver.swift
//  SwiftSenpai-Observer-In-App-Dark-Mode
//
//  Created by Lee Kah Seng on 30/11/2019.
//  Copyright © 2019 Lee Kah Seng. All rights reserved.
//


import Foundation
import UIKit

protocol UserInterfaceStyleObserver: AnyObject {
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager)
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle)
}


extension UIViewController: UserInterfaceStyleObserver {
    
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view controller as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view controller to desire style when start observing
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
        } else {
            // Fallback on earlier versions
        }
    }
    
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIViewController
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = style
        } else {
            // Fallback on earlier versions
        }
        
        // Update status bar style
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension UIView: UserInterfaceStyleObserver {
    
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view to desire style when start observing
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
        } else {
            // Fallback on earlier versions
        }
    }
    
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIView
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = style
        } else {
            // Fallback on earlier versions
        }
    }
}
