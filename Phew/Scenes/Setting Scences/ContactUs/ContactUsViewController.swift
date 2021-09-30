//
//  ContactUsViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController {
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var whatsAppLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    var facebookLink: String?, twitterLink: String?, instagramLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private func updateView() {
        title = "Contact Us".localize
        clearNavigationBackButtonTitle()
        trasperantNavBar()
        setNavBarColor()
        getSocailInfoRequest()
    }
    
    func getSocailInfoRequest() {
        repo.request(SocilaInfoModel.self, GeneralRouter.socialInfo) {[weak self] (data) in
            if let data = data {
                guard let self = self else {return}
                if data.status == "true", let social = data.data {
                    // success
                    self.phoneLbl.text    = social.mobile
                    self.whatsAppLbl.text = social.whatsappPhone
                    self.emailLbl.text    = social.email
                    
                    self.facebookLink  = social.facebookURL
                    self.twitterLink   = social.twitterURL
                    self.instagramLink = social.instagramURL
                }
            }
        }
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [facebookLink ?? ""])
    }
    
    @IBAction func twitterBtnTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [twitterLink ?? ""])
    }
    
    @IBAction func instaBtnTapped(_ sender: Any) {
        UIApplication.tryURL(urls: [instagramLink ?? ""])
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}
