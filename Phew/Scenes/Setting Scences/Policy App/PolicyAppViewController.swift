//
//  PolicyAppViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/8/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class PolicyAppViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clearNavigationBackButtonTitle()
        trasperantNavBar()
        setNavBarColor()
        self.title = "Policy".localize
        getTermsApp()
    }
    
    func getTermsApp() {
        repo.request(TermsAppModel.self, GeneralRouter.terms) {[weak self] (data) in
            if let data = data, let policy = data.data {
                guard let self = self else {return}
                if data.status == "true" {
                    self.textView.text = policy.conditionsTerms ?? ""
                }
            }
        }
    }
}
