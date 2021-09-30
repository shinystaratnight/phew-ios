//
//  SettingViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/27/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    @IBOutlet weak var switchOutlet: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UserInterfaceStyleManager.shared)
        // Do any additional setup after loading the view.
        title = "Setting".localize
        clearNavigationBackButtonTitle()
//        trasperantNavBar()
//        setNavBarColor()
        let style =  UserInterfaceStyleManager.shared.currentStyle
        switchOutlet.isOn = style.rawValue == 2 ? true : false
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        push(EditProfileViewController())
    }
    
    @IBAction func notificationBtnTapped(_ sender: Any) {
        push(NotificationSettingViewController())
    }
    
    @IBAction func premiumMembershipBtnTapped(_ sender: Any) {
        push(PremiumMembershipViewController())
    }
    
    @IBAction func aboutAppBtnTapped(_ sender: Any) {
        push(AboutAppViewController())
    }
    
    @IBAction func polciyBtnTapped(_ sender: Any) {
        push(PolicyAppViewController())
    }
    
    @IBAction func contactUsBtnTapped(_ sender: Any) {
        push(ContactUsViewController())
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        repo.request(BaseModelWith<UserData>.self, AuthRouter.logout) { (_) in
            AuthService.restartAppAndRemoveUserDefaults()
        }
    }
    
    @IBAction func darkModeSwitchValueChanged(_ sender: UISwitch) {
        
        let darkModeOn = sender.isOn
       
        // Store in UserDefaults
        UserDefaults.standard.set(darkModeOn, forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn)
        
        // Update interface style
        UserInterfaceStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
    }
}

extension UIViewController {
    func setStatusBar(color: UIColor) {
        let tag = 12321
        if let taggedView = self.view.viewWithTag(tag){
            taggedView.removeFromSuperview()
        }
        let overView = UIView()
        overView.frame = UIApplication.shared.statusBarFrame
        overView.backgroundColor = color
        overView.tag = tag
        self.view.addSubview(overView)
    }
}
