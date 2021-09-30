//
//  FriendsViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class FriendsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listFriend: [UserData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private func updateView() {
        title = "Friends".localize
        registerTableView()
        clearNavigationBackButtonTitle()
        trasperantNavBar()
        setNavBarColor()
        getFriendlistRequest()
    }
    
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: FriendsTableViewCell.self)
    }
    
    func getFriendlistRequest() {
        //change Model?
        let id = AuthService.userData?.id ?? 0
        repo.request(BaseModelWith<[UserData]>.self, FriendsRouter.listFriends(id: id)) {[weak self] (data) in
            guard let self = self else {return}
            if let data = data, data.status == "true", let listFriend = data.data {
                self.listFriend = listFriend
            }
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as FriendsTableViewCell
        let data = listFriend[indexPath.row]
        cell.dataItem = data
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension FriendsViewController: FriendsTableViewDelegate {
    func deleteFriend(id: Int) {
        repo.request(BaseModelWith<[UserData]>.self, FriendsRouter.removeRequest(id: id)) {[weak self] (data) in
            guard let self = self else {return}
            if let data = data, data.status == "true" {
                self.getFriendlistRequest()
            }
        }
    }
}
