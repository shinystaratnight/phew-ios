//
//  PremiumMembershipViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class PremiumMembershipViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private
    func updateView() {
        clearNavigationBackButtonTitle()
        trasperantNavBar()
        setNavBarColor()
        title = "Premium Membership Setting".localize
    }
    
    @IBAction func messageBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func swithButtnonTapped(_ sender: Any) {

    }
}
