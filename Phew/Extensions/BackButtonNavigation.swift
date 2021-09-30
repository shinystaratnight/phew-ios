//
//  BackButtonNavigation.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

extension UIViewController {
    func clearNavigationBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//        navigationController?.navigationBar.tintColor = .mainBlack
    }
}
