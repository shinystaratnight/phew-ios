//
//  VerifyCodeViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class VerifyCodeViewController: BaseViewController {
    
    @IBOutlet weak var codeF: UITextField!
    @IBOutlet weak var codeS: UITextField!
    @IBOutlet weak var codeT: UITextField!
    @IBOutlet weak var codeFor: UITextField!
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var activeAccountBtn: CustomRedButton!
    
    var mobile = "123456789"
    var code: Int?
    
    var timer: Timer?
    var totalTime = 65
    var countTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewWithTimer()
        clearNavigationBackButtonTitle()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    func updateViewWithTimer() {
        totalTime = 65
        sendCodeBtn.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        sendCodeBtn.isEnabled = false
        startOtpTimer()
        totalTime = totalTime - countTime
    }
    
    private
    func updateView() {
        let _ = [codeF, codeS, codeT, codeFor].map({
            $0?.keyboardType = .numberPad
            $0?.withFont(.CairoRegular(of: 15))
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(self.textfieldDidChange(textfield:)), for: UIControl.Event.editingChanged)
        })
    }
    
    @IBAction func resendCodeBtnTapped(_ sender: Any) {
        let parameters = ["mobile": mobile] as [String : Any]
        repo.request(BaseModelWith<UserData>.self, AuthRouter.resendCode(parameters)) {[weak self] (data) in
            guard self != nil else {return}
            if let data = data, data.status == "true" {
                self?.updateViewWithTimer()
            }
        }
    }
    
    @IBAction func activeAccountBtnTapped(_ sender: Any) {
        verifiyRegisterCode(mobile: mobile, code1: codeF.text, code2: codeS.text, code3: codeT.text, code4: codeFor.text)
    }
    
    func verifiyRegisterCode(mobile: String, code1: String?, code2: String?, code3: String?, code4: String?) {
        do {
            let _ = try Validator.validate(with: code1, decription: "code".localize)
            let _ = try Validator.validate(with: code2, decription: "code".localize)
            let _ = try Validator.validate(with: code3, decription: "code".localize)
            let _ = try Validator.validate(with: code4, decription: "code".localize)
            
            let firstTwoCode = code1! + code2!
            let scendTwoCode = code3! + code4!
            let myCode = Int(firstTwoCode + scendTwoCode) ?? 0
            let parameters = ["mobile": mobile, "code": myCode] as [String : Any]
            
            repo.request(BaseModelWith<UserData>.self, AuthRouter.verify(parameters)) {[weak self] (data) in
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
}

extension VerifyCodeViewController: UITextFieldDelegate {
    
    @objc func textfieldDidChange(textfield:UITextField) {
        let text = textfield.text
        if text?.utf16.count == 1 {
            switch textfield {
            case codeF:
                codeS.becomeFirstResponder()
            case codeS:
                codeT.becomeFirstResponder()
            case codeT:
                codeFor.becomeFirstResponder()
            case codeFor:
                codeFor.resignFirstResponder()
            default:
                break
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == codeF {
            codeF.text = ""
        }else if textField == codeS {
            codeS.text = ""
        }else if textField == codeT {
            codeT.text = ""
        }else if textField == codeFor {
            codeFor.text = ""
        }
    }
}

extension VerifyCodeViewController {
    
    private func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        self.labelTimer.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        }else{
            if let timer = self.timer {
                sendCodeBtn.setTitleColor(.mainRed, for: .normal)
                sendCodeBtn.isEnabled = true
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
