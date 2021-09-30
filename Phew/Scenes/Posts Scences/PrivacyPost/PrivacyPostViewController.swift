//
//  PrivacyPostViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/14/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol PrivacyPostViewDelegate: AnyObject {
    func friendOlnyTapped()
    func allTapped()
}

class PrivacyPostViewController: UIViewController {
    
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var friendsLbl: UILabel!
    @IBOutlet weak var allLbl: UILabel!
    
    @IBOutlet weak var friendsRadioView: CircleImageView!
    @IBOutlet weak var allRadioView: CircleImageView!
    
    weak var delegate: PrivacyPostViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private
    func updateView() {
        postLbl.withFont(.CairoSemiBold(of: 15))
            .textColor = .mainRed
        friendsRadioView.backgroundColor = .mainBlack
        allRadioView.backgroundColor = .mainBlack
        allRadioView.isHidden = true
        let _ = [friendsLbl,allLbl].map({
            $0?.withFont(.CairoRegular(of: 15))
                .textColor = .mainBlack
        })
    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func friendsBtnTapped(_ sender: Any) {
        allRadioView.isHidden = true
        friendsRadioView.isHidden = false
        delegate?.friendOlnyTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allbleBtnTapped(_ sender: Any) {
        friendsRadioView.isHidden = true
        allRadioView.isHidden = false
        delegate?.allTapped()
        dismiss(animated: true, completion: nil)
    }
}
