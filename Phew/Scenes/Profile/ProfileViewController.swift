//
//  ProfileViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/13/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    var vcIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
        
        if vcIdentifier == "mine" {
            addFriendBtn.isHidden = true
            followBtn.isHidden    = true
        }
    }
    
    @IBAction func friendsBtnTapped(_ sender: Any) {
        let vc = FriendsViewController()
        push(vc)
    }
    
    @IBAction func addFriendBtnTapped(_ sender: Any) {
        repo.request(BaseModelWith<UserData>.self, FriendsRequestRouter.sendFriendRequest(id: 1)) {[weak self] (data) in
            guard self != nil else {return}
            if let data = data, data.status == "true", let userData = data.data {
                print(userData)
            }
        }
    }
    
    @IBAction func followBtnTapped(_ sender: Any) {
        repo.request(BaseModelWith<UserData>.self, FollowtRouter.followUnFollow(id: 1)) {[weak self] (data) in
            guard self != nil else {return}
            if let data = data, data.status == "true", let userData = data.data {
                print(userData)
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SharePostTableViewCell
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                tableViewHeight.constant = newSize.height
                viewHieght.constant = newSize.height + 450
            }
        }
    }
}



// MARK:- Setup View
extension ProfileViewController {
    
    fileprivate func updateView() {
        title = "Mohamed Akl"
        trasperantNavBar()
        setNavBarColor()
        registerTableView()
        
        addFriendBtn.viewCornerRadius = 7
        addFriendBtn.withFont(.CairoRegular(of: 15))
        addFriendBtn.viewBorderColor = .mainWhite
        addFriendBtn.viewBorderWidth = 0.7
        addFriendBtn.setTitleColor(.mainWhite, for: .normal)
        
        followBtn.viewCornerRadius = 7
        followBtn.withFont(.CairoRegular(of: 15))
        followBtn.setTitleColor(.mainBlack, for: .normal)
    }
    
    fileprivate func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: SharePostTableViewCell.self)
        tableView.isScrollEnabled = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
}
