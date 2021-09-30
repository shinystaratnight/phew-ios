//
//  EditPasswordViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/29/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class EditPasswordViewController: BaseViewController {

    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        editPassword()
    }
}

extension EditPasswordViewController {
    private func editPassword() {
        do {
            let oldPassword = try Validator.validatePassword(with: txtOldPassword.text)
            let newPassword = try Validator.validatePassword(with: txtNewPassord.text)
            let _ =  try Validator.validateTwoPasswords(password: oldPassword, confirmPassword: newPassword)
            
            let parameters = [
                "_method": "PUT",
                "old_password": oldPassword,
                "password": newPassword,
                ]as [String: Any]
            
            repo.request(BaseModelWith<UserData>.self, ProfileRouter.updatePassword(parameters: parameters)) {[weak self] (data) in
                guard self != nil else {return}
                if let data = data, data.status == "true" {
                    self?.popMe()
                }
            }
        } catch let error as ValidatorError {
            showAlert(with: error.associatedMessage)
        } catch { }

    }
}
