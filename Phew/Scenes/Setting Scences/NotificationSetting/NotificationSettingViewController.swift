//
//  NotificationSettingViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/8/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class NotificationSettingViewController: BaseViewController {
    
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var newFollowersLbl: UILabel!
    @IBOutlet weak var signalLbl: UILabel!
    
    @IBOutlet weak var switchMenstions: UISwitch!
    @IBOutlet weak var switchNewFollwers: UISwitch!
    @IBOutlet weak var switchAllNotification: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        setNotification()
    }
    
    private
    func updateView() {
        title = "Notifications".localize
        clearNavigationBackButtonTitle()
        trasperantNavBar()
        setNavBarColor()
        notificationLbl
            .withFont(.CairoBold(of: 15))
            .textColor = .mainBlack
        
        let _ = [newFollowersLbl,signalLbl].map({
            $0?.withFont(.CairoRegular(of: 15))
            $0?.textColor = .mainBlack
        })
    }
    
    private func setNotification() {
        let setting = AuthService.userData?.userSettings
        switchAllNotification.isOn = (setting?.allNotices ?? 0) == 1 ? true : false
        switchNewFollwers.isOn = (setting?.notificationToNewFollowers ?? 0) == 1 ? true : false
        switchMenstions.isOn = (setting?.notificationToMention ?? 0) == 1 ? true : false
    }
    
    @IBAction func allNotificationSwitchBtn(_ sender: UISwitch) {
        let value = sender.isOn ? 1 : 0
        updateSetting(key: "all_notices", value: value)
    }
    
    @IBAction func newFollowersSwitchBtn(_ sender: UISwitch) {
        let value = sender.isOn ? 1 : 0
        updateSetting(key: "notification_to_new_followers", value: value)
        
    }
    
    @IBAction func signalSwitchBtn(_ sender: UISwitch) {
        let value = sender.isOn ? 1 : 0
        updateSetting(key: "notification_to_mention", value: value)
        
    }
}
extension NotificationSettingViewController {
    private func updateSetting(key: String, value: Int) {
        let para: [String: Any] = [
            "_method": "PUT",
            key: value]
        repo.request(BaseModelWith<UserData>.self, ProfileRouter.updateSetting(parameters: para)) { [weak self](response) in
            guard let userData = response?.data else {return}
            AuthService.userData = userData
            self?.setNotification()
        }
    }
}
 
