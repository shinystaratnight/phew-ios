//
//  MyFriendsViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/27/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class MyFriendsViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblFriendsCount: UILabel!
    private var arrFriends: [FriendsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniTableview()
        listMyFriends()
        clearNavigationBackButtonTitle()
    }
}

extension MyFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func iniTableview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 70
        tableview.register(UINib(nibName: "MyFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFriendsTableViewCell"
        )
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as! MyFriendsTableViewCell
        cell.deleget = self
        cell.item = arrFriends[indexPath.row]
        return cell
    }
}
 
extension MyFriendsViewController: MyFriendsTableViewCellProtocol {
    func removeFriend(id: Int) {
        self.remveFriend(id: id)
    }
}

extension MyFriendsViewController {
    private func listMyFriends() {
        guard let id = AuthService.userData?.id else {return}
        repo.request(FriendsDataModel.self, FriendsRouter.listFriends(id: id)) { [weak self](response) in
            guard let data = response?.data else{return}
            self?.arrFriends = data
            self?.updateCountFriends()
            self?.tableview.reloadData()
        }
    }
    
    private func remveFriend(id: Int) {
        repo.request(BaseModelData.self, FriendsRouter.removeRequest(id: id)) { [weak self] (response) in
            if let status = response?.status, status == "true" {
                self?.removeCell(id: id)
            }
        }
    }
    private func removeCell(id: Int) {
        guard let index = arrFriends.firstIndex(where: {$0.user?.id == id}) else{return}
        arrFriends.remove(at: index)
        tableview.beginUpdates()
        tableview.deleteRows(at: [IndexPath(row: index, section: 0)], with: .middle)
        tableview.endUpdates()
        updateCountFriends()
    }
    
    private func updateCountFriends() {
        self.lblFriendsCount.text = "You have ".localize + String(arrFriends.count) + " friends now".localize
    }
    
}
