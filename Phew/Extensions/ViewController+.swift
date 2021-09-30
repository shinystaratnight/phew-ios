//
// UIViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func customPresent(_ vc: UIViewController) {
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc ,animated: true, completion: nil)
    }
    
    func presentModelyVC(_ vc: UIViewController) {
        vc.definesPresentationContext = true
        if #available(iOS 13, *) {
            // vc.modalPresentationStyle = .fullScreen
        } else {
            vc.modalPresentationStyle = .custom
        }
        present(vc, animated: true, completion: nil)
    }
    
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popMe() {
        navigationController?.popViewController(animated: true)
    }
    
    func popMe(after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func popToRoot(after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showAlert(title: String? = "", message: String?, selfDismissing: Bool = true, time: TimeInterval = 1) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = title
        alert.message = message
        if !selfDismissing {
            alert.addAction(UIAlertAction(title: "Ok".localize, style: .cancel, handler: nil))
        }
        
        present(alert, animated: true)
        
        if selfDismissing {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
                t.invalidate()
                alert.dismiss(animated: true)
            }
        }
    }
    
    func trasperantNavBar() {
//        navigationController?.navigationBar.isOpaque = true
//        navigationController?.navigationBar.backgroundColor = .clear
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.setNavigationBarHidden(false, animated:true)
        // navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setNavBarColor() {
//        setStatusBar(color: .mainRed)
//        navigationController?.navigationBar.backgroundColor = .mainColor
//        navigationController?.navigationBar.tintColor = .mainWhite
        // navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setImageTitle() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "profilee")
        imageView.image = image
        navigationItem.titleView = imageView
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setStatusBarBackgroundColor(color: UIColor = .mainColor) {
        if #available(iOS 13, *) {
            //            let window = AppDelegate.shared.window
        } else {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = color
        }
    }
    
    func navbarWithdismiss() {
        let exitButton = UIBarButtonItem(title: "Back".localize, style: .plain, target: self, action: #selector(dismissMePlease))
        navigationItem.rightBarButtonItem = exitButton
    }
    
    @objc func dismissMePlease() {
        dismiss(animated: true, completion: nil)
    }
    
    func setTitle(_ title: String) {
        navigationItem.title = title
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.CairoBold(of: 16), .foregroundColor: UIColor.mainWhite]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
}

extension UIViewController {
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    func removeNotificationsObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIViewController {
    
    var toNavigation: UINavigationController {
        let nav = UINavigationController(rootViewController: self)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        nav.navigationBar.titleTextAttributes = textAttributes
        nav.navigationBar.barTintColor = UIColor.NavColor
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.prefersLargeTitles = false
        nav.navigationBar.tintColor = UIColor.white
        return nav
    }
}

extension BaseViewController {
    func dissmissView(view : UIView) {
        if #available(iOS 13, *) {
            return
        } else {
            let swip = UISwipeGestureRecognizer(target: self, action:#selector(dismissMePlease))
            view.addGestureRecognizer(swip)
            swip.direction = .down
        }
    }
}

extension BaseViewController {
    var isIOS13: Bool {
        if #available(iOS 13, *) {
            return true
        } else {
            return false
        }
    }
    
    
}

extension UIViewController {
    func addChildViewController(childViewController: UIViewController, childViewControllerContainer: UIView, comp: (() -> ())? = nil) {
        
        removeChildViewControllers()
        
        addChild(childViewController)
        
        childViewControllerContainer.addSubview(childViewController.view)
        childViewController.view.frame = childViewControllerContainer.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.view.backgroundColor = .clear
        childViewController.view.subviews.forEach { view in
            view.backgroundColor = .clear
        }
        childViewController.didMove(toParent: self)
        comp?()
    }
    
    func removeChildViewControllers() {
        if children.count > 0 {
            for i in  0..<children.count {
                children[i].willMove(toParent: nil)
                children[i].view.removeFromSuperview()
                children[i].removeFromParent()
            }
        }
    }
    
//    func toNavigation()->UINavigationController{
//        let nav = UINavigationController(rootViewController: self)
//        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        nav.navigationBar.titleTextAttributes = textAttributes
//        nav.navigationBar.barTintColor = UIColor.baseColor
//        nav.navigationBar.tintColor = UIColor.white
//        return nav
//    }
    
}
