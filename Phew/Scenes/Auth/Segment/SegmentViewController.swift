//
//  SegmentViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/25/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class SegmentViewController: BaseViewController {
    
    private lazy var selectionView = UIView()
        .withBackColor(.backgroundColor)
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var viewRegister: UIView!
    @IBOutlet weak var viewLogin: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handleSelect(button: loginBtn)
        handleLoginSegmentView()
        logoImageView.tintColor = .mainRed
//        navigationController?.isNavigationBarHidden = true
        setSelectedView(selectedView: viewLogin)
        loginBtn.setTitleColor(.mainColor, for: .normal)
        navigationController?.navigationBar.tintColor = .mainColor
        trasperantNavBar()
        registerBtn.setTitleColor(.lightGray, for: .normal)
    }
    
    private func handleLoginSegmentView() {
        let vc = LoginViewController()
        addChildViewController(childViewController: vc, childViewControllerContainer: views)
    }
    
    private func handleRegisterSegmentView() {
        let vc = RegisterViewController()
        addChildViewController(childViewController: vc, childViewControllerContainer: views)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        handleSelect(button: loginBtn)
        handleLoginSegmentView()
        setSelectedView(selectedView: viewLogin)
        loginBtn.setTitleColor(.mainColor, for: .normal)
        registerBtn.setTitleColor(.lightGray, for: .normal)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        handleSelect(button: registerBtn)
        handleRegisterSegmentView()
        setSelectedView(selectedView: viewRegister)
        registerBtn.setTitleColor(.mainColor, for: .normal)
        loginBtn.setTitleColor(.lightGray, for: .normal)
    }
    
    private func handleSelect(button: UIButton) {
        _ = [loginBtn, registerBtn]
            .filter({ $0 != button })
//            .map({ $0.withTitleColor(.mainColor) })
//        button.withTitleColor(.mainColor)
        
        selectionView.removeFromSuperview()
        
        button.addSubview(selectionView.withHeight(2.3))
        selectionView.withWidthToSuperViewWith(0.98)
        selectionView.centerXInSuperview()
        selectionView.bottomAnchorSuperView()
    }
    
    private func setSelectedView(selectedView: UIView) {
        [viewLogin, viewRegister].forEach({
            $0?.backgroundColor = .clear
        })
        selectedView.backgroundColor = .mainColor
    }
}
