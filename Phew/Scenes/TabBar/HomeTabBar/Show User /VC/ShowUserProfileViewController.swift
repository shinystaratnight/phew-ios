//
//  ShowUserProfileViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/23/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ShowUserProfileViewController: BaseViewController {
    
    private var userId: Int
    private var user: User?
    private var count = 3
    let settingButton: UIButton = UIButton(type: .system)
        .withImage(#imageLiteral(resourceName: "Group 522"))
        .withSize(.init(all: 40))
        .withWidth(20)
        .withHeight(20) as! UIButton
    let btnPackage: UIButton = UIButton()
        .withImage(#imageLiteral(resourceName: "premium"))
        .withSize(.init(all: 40))
        .withWidth(20)
        .withHeight(20) as! UIButton
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customImageNavigation()

        featchUserProfile()
    
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { notification in
            print("Screenshot taken!")
        }
    } //
    private func customImageNavigation() {
        navigationItem.rightBarButtonItems = [.init(customView: settingButton), .init(customView: btnPackage)]
        settingButton.addTarget(self, action: #selector(navToSearch), for: .touchUpInside)
        btnPackage.addTarget(self, action: #selector(navToPackage), for: .touchUpInside)
    }
    
    @objc func navToSearch() {
        push(SettingViewController())
    }
    
    @objc func navToPackage() {
        push(PackageViewController())
    }
    func addVC(user: User) {
        addChildViewController(childViewController: CustomeViewController(user: user, type: .userProfile), childViewControllerContainer: view)
    }
}

extension ShowUserProfileViewController {
    private func featchUserProfile() {
        repo.request(BaseModelWith<User>.self, ProfileRouter.profile(id: userId)) { [weak self](response) in
            guard let data = response?.data else{return}
            self?.user = data
            self?.addVC(user: data)
            self?.setTitle(data.fullname ?? "")
        }
    }
}
