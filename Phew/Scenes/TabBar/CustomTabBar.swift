//
//  CustomTabBar.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
private extension UIViewController {
    func withTabBarItem(image: UIImage, name: String? = nil, selectedImage: UIImage? = nil) -> UIViewController {
        tabBarItem = UITabBarItem(title: name, image: image, selectedImage: selectedImage)
        // tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        title = nil
        return self
    }
}
class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        updateView()
        setupTabBar()
        tabBar.barTintColor = UIColor.white
    }
    
    private func updateView() {
//        tabBar.tintColor = .mainColor
    }
    
    private func setupTabBar() {
        
        let homeVC = HomeTabBarViewController()
            .toNavigation
//            .withTabBarItem(image: #imageLiteral(resourceName: "privacy_policy").original)
            .withTabBarItem(image:  #imageLiteral(resourceName: "privacy_policy"), name: "", selectedImage: #imageLiteral(resourceName: "feeds_a").original)
        
        
        let citiesVC = CitiesTabBarViewController()
            .toNavigation
            .withTabBarItem(image:  UIImage(named: "findely_d")!, name: "", selectedImage: #imageLiteral(resourceName: "findely_a").original)
        
        let notificationVC = NotificationTabBarViewController()
            .toNavigation
//            .withTabBarItem(image: #imageLiteral(resourceName: "notification"))
            .withTabBarItem(image:  #imageLiteral(resourceName: "notification"), name: "", selectedImage: #imageLiteral(resourceName: "Notification_a").original)
        
        let messagesVC = MessagesTabBarViewController()
            .toNavigation
//            .withTabBarItem(image: #imageLiteral(resourceName: "message_settings"))
            .withTabBarItem(image:  #imageLiteral(resourceName: "message_settings"), name: "", selectedImage: #imageLiteral(resourceName: "chat_a").original)
        
        viewControllers = [homeVC, citiesVC, notificationVC, messagesVC]
    }
}

private extension UIViewController {
    func withTabBarItem(image: UIImage, name: String? = nil) -> UIViewController {
        tabBarItem = UITabBarItem(title: name, image: image, selectedImage: image)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        title = nil
        return self
    }
}
