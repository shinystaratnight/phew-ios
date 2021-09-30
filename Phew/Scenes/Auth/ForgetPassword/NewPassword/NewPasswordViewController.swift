//
//  NewPasswordViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/8/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class NewPasswordViewController: BaseViewController {
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    
    var mobile: String?, code: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private func updateView() {
        hideKeyboard()
//        let _ = [passwordTxt,confirmPassTxt].map({
//            $0?.keyboardType = .default
//            $0?.withLeadingImage(#imageLiteral(resourceName: "password").template)
//            $0?.withFont(.CairoRegular(of: 15))
//            .secure
//        })
    }
    
    @IBAction func savePasswordTapped(_ sender: Any) {
        
    }
    
}
