//
//  SplashViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/10/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit
import MOLH
class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.reset()
            print("DDDDDDDD")
        }
    }
//    func setStatusBarColor(to color: UIColor) {
//        if #available(iOS 13.0, *) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
//                statusBar.backgroundColor = color
//                UIView.animate(withDuration: 0.5) {
//                    UIApplication.shared.keyWindow?.addSubview(statusBar)
//                }
//            }
//        } else {
//            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//            statusBar?.backgroundColor = color
//        }
//    }
}

extension SplashViewController : MOLHResetable {
    func reset() {
//        setStatusBarColor(to: .NavColor)
        if Validator.isUserLoggedIn {
            AppDelegate.shared.window?.rootViewController = TabBarController()
        } else {
            AppDelegate.shared.window?.rootViewController = SegmentViewController().toNavigation
        }
    }
}
