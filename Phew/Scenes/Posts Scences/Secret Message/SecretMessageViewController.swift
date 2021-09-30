//
//  SecretMessageViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/25/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class SecretMessageViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var btnPostOutlet: UIButton!
    @IBOutlet weak var txtMessage: RSKPlaceholderTextView!
    
    private var userId: Int
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMessage.placeholder = "Enter Message".localize as NSString
        isActiveButtonPost(false)
        setTitle("Secret Message".localize)
        txtMessage.delegate = self
    }
    
    @IBAction func btnSendMessageTapped(_ sender: Any) {
        sendMessage()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let value = textView.text.trimmedString
        if value.isEmpty{
            isActiveButtonPost(false)
        }else{
            isActiveButtonPost(true)
        }
    }
    
    private func isActiveButtonPost(_ active:Bool) {
        if active {
            btnPostOutlet.backgroundColor = UIColor.red
            btnPostOutlet.isEnabled  = true
        }else{
            btnPostOutlet.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            btnPostOutlet.isEnabled  = false
        }
    }
}

extension SecretMessageViewController {
    private func sendMessage() {
        guard txtMessage.text.count > 0 else {return}
        repo.request(BaseModel.self, SecretMessageRouter.endMessage(userId: userId, message: txtMessage.text)) { [weak self] (response) in
            DispatchQueue.main.async {
                self?.dismissMePlease()
            }
            
        }
    }
}
