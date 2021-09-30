//
//  RegisterViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
import GoogleSignIn
class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var userNametxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
//    @IBOutlet weak var countryBtn: UIButton!
//    @IBOutlet weak var cityBtn: UIButton!
    
    private var countries: [CountryModel] = []
    private var cities: [CityModel] = []
    
//    private var selectedCountryId: Int?
//    private var selectedCityId: Int?
//    private let imagePicker = PickImageVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    private func updateView() {
        hideKeyboard()
        userNametxt
            .withLeadingImage(#imageLiteral(resourceName: "profilee").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .default
        
        emailTxt
            .withLeadingImage(#imageLiteral(resourceName: "mail").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .emailAddress
        
        phoneTxt
            .withLeadingImage(#imageLiteral(resourceName: "myphone").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .phonePad
        
        passwordTxt
            .secure
            .withLeadingImage(#imageLiteral(resourceName: "password").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .default
        
        confirmPassTxt
            .secure
            .withLeadingImage(#imageLiteral(resourceName: "password").template)
            .withFont(.CairoRegular(of: 15))
            .keyboardType = .default
        
//        let _ = [countryBtn,cityBtn].map({
//            $0?.viewBorderWidth = 1
//            $0?.viewBorderColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1).withAlphaComponent(0.9)
//            $0?.viewCornerRadius = 5
//            $0?.setTitleColor(#colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1), for: .normal)
//        })
        
        repo.request(BaseModelWith<[CountryModel]>.self, GeneralRouter.country) { (data) in
            self.countries = data?.data ?? []
        }
    }
    
//    @IBAction func countryBtnTapped(_ sender: Any) {
//        cityBtn.setTitle("City".localize, for: .normal)
//        let vc = PickerViewController(itemsToShow: countries.map({($0.name ?? "")}), delegate: nil)
//        vc.selectedItem = {[weak self] item in
//            self?.countryBtn.setTitle(item, for: .normal)
//            self?.countryBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//
//            let nationId = self?.countries.first(where: { $0.name == item })?.id
//            self?.selectedCountryId = nationId
//            self?.getCity(countryId: nationId ?? 0)
//        }
//        presentModelyVC(vc)
//    }
    
//    func getCity(countryId: Int) {
//        repo.request(BaseModelWith<[CityModel]>.self, GeneralRouter.city(country: countryId)) { (data) in
//            self.cities = data?.data ?? []
//        }
//    }
//    
//    @IBAction func cityBtnTapped(_ sender: Any) {
//        if selectedCountryId != nil {
//            let vc = PickerViewController(itemsToShow: cities.map({($0.name ?? "")}), delegate: nil)
//            vc.selectedItem = {[weak self] item in
//                self?.cityBtn.setTitle(item, for: .normal)
//                self?.cityBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//                
//                let cityId = self?.cities.first(where: { $0.name == item })?.id
//                self?.selectedCityId = cityId
//            }
//            presentModelyVC(vc)
//        }else{
//            showAlert(with: "Please Choose Country First".localize)
//            return
//        }
//    }
    
    @IBAction func btnLoginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        do {
            let userName = try Validator.validate(with: userNametxt.text, decription: "User Name".localized)
            let email = try Validator.validateMail(with: emailTxt.text)
            let mobile = try Validator.validate(with: phoneTxt.text, decription: "Mobile Number".localized)
//            let countryId = try Validator.validate(with: selectedCountryId, decription: "Country".localized)
//            let cityId = try Validator.validate(with: selectedCityId, decription: "City".localized)
            let password = try Validator.validateTwoPasswords(password: passwordTxt.text, confirmPassword: confirmPassTxt.text)

            let parameters = [
                "fullname": userName,
                "mobile": mobile,
                "email": email,
//                "country_id": countryId,
//                "city_id": cityId,
                "password": password,
                "device_type": "ios",
                "device_token": FirebaseMessagingManger.firebaseMessagingToken
            ].compactMapValues({ $0 })
            
//            func upload<U: BaseCodable>(_ model: U.Type, _ request: URLRequestConvertible, data: [UploadData], completionHandler: @escaping(_ data: U?)->()) {
            repo.request(BaseModel.self, AuthRouter.register(parameters)) { [weak self] base in
                if let base = base, base.status == "true" {
                    let vc = VerifyCodeViewController()
                    vc.mobile = mobile
                    self?.push(vc)
                }
            }
//            repo.upload(BaseModel.self, AuthRouter.register(parameters), data: images) { [weak self](data) in
//                if let data = data {
//                    if data.status == "true" {
//
//                    }
//                }
//            }

        } catch let error as ValidatorError {
            showAlert(with: error.associatedMessage)
        } catch { }
    }
}

extension RegisterViewController: GIDSignInDelegate {
    
    
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
