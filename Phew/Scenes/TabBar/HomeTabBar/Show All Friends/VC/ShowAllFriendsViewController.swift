//
//  ShowAllFriendsViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ShowAllFriendsViewController: BaseViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    private var arrFriends: [User] = []
    
    init(friends: [User]) {
        self.arrFriends = friends
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        iniTableview()
    }
}
extension ShowAllFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    private func iniTableview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 70
        tableview.register(UINib(nibName: "ShowFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowFriendsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ShowFriendsTableViewCell", for: indexPath) as! ShowFriendsTableViewCell
        cell.item = arrFriends[indexPath.row]
        cell.deleget = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = arrFriends[indexPath.row].id else{return}
        push(ShowUserProfileViewController(userId: id))
    }
    
}
extension ShowAllFriendsViewController: ShowFriendsTableViewCellProtocol {
    func followUser(userId: Int) {
        follow(id: userId)
    }
}
//FollowDataModel
extension ShowAllFriendsViewController {
    private func follow(id: Int) {
        repo.request(FollowDataModel.self, FollowtRouter.followUnFollow(id: id)) { [weak self] (response) in
            guard let isFollow = response?.data?.isFollow else {return}
            guard let index = self?.arrFriends.firstIndex(where: {$0.id == id}) else {return}
            self?.arrFriends[index].isFollow = isFollow
            self?.tableview.reloadRows(at: [IndexPath(row: index, section: 0)], with: .right)
        }
    }
}
