//
//  ShareViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/16/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var quoteRtweetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private func updateView() {
        let _ = [retweetBtn,quoteRtweetBtn].map({
            $0?.withFont(.CairoRegular(of: 15))
            $0?.setTitleColor(.mainBlack, for: .normal)
        })
        
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retweetBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func quoteBtnTapped(_ sender: Any) {
        
    }
}
