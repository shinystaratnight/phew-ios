//
//  AboutAppViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class AboutAppViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clearNavigationBackButtonTitle()
        trasperantNavBar()
        setNavBarColor()
        self.title = "About App".localize
        getAboutApp()
    }
    
    func getAboutApp() {
        repo.request(AboutAppModel.self, GeneralRouter.about) {[weak self] (data) in
            if let data = data {
                guard let self = self else {return}
                if data.status == "true", let about = data.data {
                    // success
                    self.textView.text = about.about ?? ""
                }
            }
        }
    }
}
