//
//  FriendsTakeScreenShotViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/19/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class FriendsTakeScreenShotViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    private var arrFriends: [User] = []
    
    init(users: [User]) {
        self.arrFriends = users
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        lblCount.text = "\(arrFriends.count)" + " Friends take screenshot for youe screen".localize
        viewContainer.layer.cornerRadius = 10
        iniTableview()
    }
}
extension FriendsTakeScreenShotViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.itemUser = arrFriends[indexPath.row]
        return cell
    }
}
