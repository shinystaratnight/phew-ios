//
//  ForgetPasswordViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/8/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var phoneTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearNavigationBackButtonTitle()

        updateView()
    }
    
    private func updateView() {
        hideKeyboard()
        phoneTxt
            .withLeadingImage(#imageLiteral(resourceName: "myphone").template)
            .keyboardType = .numberPad
    }
    
    @IBAction func sendCodeTapped(_ sender: Any) {
        forgetPasswordRequest(mobile: phoneTxt.text)
    }
    
    func forgetPasswordRequest(mobile: String?) {
        do {
            let mobile = try Validator.validate(with: mobile, decription: "Mobile Number".localize)
            let parameters = ["mobile": mobile] as [String : Any]
            
            repo.request(BaseModelWith<UserData>.self, AuthRouter.forgetPassword(parameters)) {[weak self] (data) in
                guard let self = self else {return}
                if let data = data, data.status == "true" {
                    let vc = VerfiyPasswordCodeViewController()
                    vc.mobile = mobile
                    self.push(vc)
                }
            }
        } catch let error as ValidatorError {
            showAlert(with: error.associatedMessage)
        } catch { }
    }
}
