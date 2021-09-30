//
//  LoginViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    private func updateView() {
        hideKeyboard()
        phoneTxt
            .withLeadingImage(#imageLiteral(resourceName: "profilee").template)
            .withFont(.CairoRegular(of: 15))
        
        passwordTxt
            .secure
            .withLeadingImage(#imageLiteral(resourceName: "password").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .default
    }
    
    @IBAction func forgetPasswordTapped(_ sender: Any) {
        push(ForgetPasswordViewController())
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        login(email: phoneTxt.text, password: passwordTxt.text)
    }
    
    @IBAction func btnGoogleLoginTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func login(email: String?, password: String?) {
        do {
            let email = try Validator.validate(with: email, decription: "Identifier".localized)
            let password = try Validator.validatePassword(with: password)
            
            let parameters = [
                "identifier": email,
                "password": password,
                "device_type": "ios",
                "device_token": FirebaseMessagingManger.firebaseMessagingToken
            ] as [String: Any]
            
            repo.request(BaseModelWith<UserData>.self, AuthRouter.login(parameters)) {[weak self] (data) in
                guard self != nil else {return}
                if let data = data, data.status == "true", let userData = data.data {
                    AuthService.userData = userData
                    AuthService.goToHomeScreenAfterLogin()
                }
            }
        } catch let error as ValidatorError {
            showAlert(with: error.associatedMessage)
        } catch { }
    }
    func loginSocial(name: String, providerId: String) {
        let parameters = [
            "fullname": name,
            "provider_type": "google",
            "device_type": "ios",
            "device_token": FirebaseMessagingManger.firebaseMessagingToken,
            "provider_id": providerId
        ] as [String: Any]
        
        repo.request(BaseModelWith<UserData>.self, AuthRouter.loginSocial(parameters)) {[weak self] (data) in
            guard self != nil else {return}
            if let data = data, data.status == "true", let userData = data.data {
                AuthService.userData = userData
                AuthService.goToHomeScreenAfterLogin()
            }
        }
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_: GIDSignIn!, dismiss _: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    func sign(_: GIDSignIn!, didDisconnectWith _: GIDGoogleUser!,
              withError _: Error!) {}
    
    func sign(inWillDispatch _: GIDSignIn!, error _: Error!) {}
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _error = error {
            showAlert(message: _error.localizedDescription)
        }else {
            let idToken = user.userID ?? ""
            let givenName = user.profile.givenName ?? ""
            let familyName = user.profile.familyName ?? ""
            let name = "\(givenName) \(familyName)"
            loginSocial(name: name, providerId: idToken)
        }
    }
}
