//
//  WaitingFriendViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 9/15/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class WaitingFriendViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var arrFriends: [FriendsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    private func updateView() {
        registerTableView()
        setTitle("Friend Request".localize)
        clearNavigationBackButtonTitle()
//        trasperantNavBar()
//        setNavBarColor()
        featchFriendsRequest()
    }
    
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: FriendsNotificationsTableViewCell.self)
    }
}

extension WaitingFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as FriendsNotificationsTableViewCell
        cell.delegate = self
        cell.item = arrFriends[indexPath.row]
        return cell
    }
}

extension WaitingFriendViewController: FriendsNotificationsDelegate {
    
    func acceptButtonTapped(cell: FriendsNotificationsTableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        let id = arrFriends[index].user?.id ?? 0
        repo.request(BaseModelWith<UserData>.self, FriendsRequestRouter.acceptFriendRequest(id: id)) {[weak self] (data) in
            guard self != nil else {return}
            if let data = data, data.status == "true" {
                self?.removeCell(id: id)
            }
        }
    }
    
    func cancelButtonTapped(cell: FriendsNotificationsTableViewCell){
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        let id = arrFriends[index].user?.id ?? 0
        repo.request(BaseModelWith<UserData>.self, FriendsRequestRouter.rejectFriendRequest(id: id)) {[weak self] (data) in
            guard self != nil else {return}
            if let data = data, data.status == "true" {
                self?.removeCell(id: id)
            }
        }
    }
    
    private func featchFriendsRequest() {
        guard let id = AuthService.userData?.id else{return}
        repo.request(FriendsDataModel.self, FriendsRequestRouter.listFriendsRequest(id: id)) { [weak self] (response) in
            guard let data = response?.data else{return}
            self?.arrFriends = data
            self?.tableView.reloadData()
        }
    }
    
    private func removeCell(id: Int) {
        guard let index = arrFriends.firstIndex(where: {$0.user?.id == id}) else{return}
        arrFriends.remove(at: index)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .middle)
        tableView.endUpdates()
    }
    
    
}
