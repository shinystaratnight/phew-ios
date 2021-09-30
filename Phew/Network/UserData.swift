//
//  UserData.swift
//  Torch
//
//  Created by Youssef on 8/11/19.
//  Copyright © 2019 Youssef. All rights reserved.
//

import UIKit
import MOLH

class AuthService {
        
    private init () { }
    
    private let userDataKey = "_User_|_Data_"
    
    private static let userDefault = UserDefaults.standard
    
    private let defaults = UserDefaults.standard
    
    fileprivate func getUserData() -> UserData? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: userDataKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(UserData.self, from: savedPerson) {
                return loadedData
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    fileprivate func setUserData(_ newValue: UserData?) {
        guard let newValue = newValue else {
            defaults.set(nil, forKey: userDataKey)
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newValue) {
            defaults.set(encoded, forKey: userDataKey)
        } else {
            fatalError("Unable To Save User Data")
        }
    }
    
    static var userData: UserData? {
        get {
            let authService = AuthService()
            return authService.getUserData()
        } set {
            let authService = AuthService()
            authService.setUserData(newValue)
        }
    }
}

extension AuthService {
    
    static func restartAppAndRemoveUserDefaults() {
        AuthService.userData = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let window =  UIApplication.shared.keyWindow else { fatalError() }
            window.rootViewController = SegmentViewController().toNavigation
            UIView.transition(with: window, duration: 1.0, options: .curveEaseIn, animations: nil, completion: nil)
        }
    }
    
   @objc static func goToHomeScreenAfterLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let window =  UIApplication.shared.keyWindow else { fatalError() }
            window.rootViewController = TabBarController()
            UIView.transition(with: window, duration: 1.0, options: .curveEaseIn, animations: nil, completion: nil)
        }
    }
    
    static var isArabic: Bool {
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            return true
        } else {
            return false
        }
    }
    
  @objc func rest() {
        MOLH.reset()
    }
}
