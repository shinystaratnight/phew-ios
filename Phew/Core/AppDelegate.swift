//
//  AppDelegate.swift
//  Phew
//1- Login with google and in register
//2- remove country and city not because findaly
// 3-
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
// https://api.themoviedb.org/3/movie/550?api_key=b9aa09eb38643436e7f8e12a1ba2e953&callback=Avata
//56aa45f1df97ffaa8d4a935c6274f307
import UIKit
import IQKeyboardManagerSwift
import MOLH
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    //com.googleusercontent.apps.844584857577-qe8ppg3j0sqh0k7oc4ako5b17skjfv0o
    
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //"848374501944-hegj4ghvvvj4583ui1f6c114dbqnem2o.apps.googleusercontent.com"
        window = UIWindow()
        window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
//        window?.backgroundColor = .white
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "844584857577-sahv9h5ssbangvhgtup62u51buk8rvfo.apps.googleusercontent.com"
        
        //"844584857577-qe8ppg3j0sqh0k7oc4ako5b17skjfv0o.apps.googleusercontent.com"
        MOLH.shared.activate()
        MOLH.setLanguageTo("en")
//        setStatusBarColor(to: .NavColor)
//        window?.rootViewController = TextVC().toNavigation
//        setStatusBarColor(to: #colorLiteral(red: 0.8804368377, green: 0.116673775, blue: 0.1732776761, alpha: 1))
//        reset()
        
        window?.rootViewController = SplashViewController()
        
        return true
    }
    
    func reset() {
        if AuthService.userData != nil {
            let nav = UINavigationController(rootViewController: TabBarController())
            nav.setNavigationBarHidden(true, animated: false)
            window?.rootViewController = nav
        } else {
            window?.rootViewController = SegmentViewController().toNavigation
        }
    }
    
//    func setStatusBarColor(to color: UIColor) {
//        if #available(iOS 13.0, *) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
