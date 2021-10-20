//
//  NotificationTabBarViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

struct Notifications {
    let notificationKey: String?
    
    init (notificationKey: String) {
        self.notificationKey = notificationKey
    }
}

class NotificationTabBarViewController: BaseViewController {
    
    @IBOutlet weak var topSV: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countFriendLbl: UILabel!
    private var refreshControl = UIRefreshControl()
    private var arrNotification: [NotificationModel] = []
    
    private var lastContentOffset: CGFloat = 0
    var isShowBarButtons: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTableView()
        setTitle("Notifications".localize)
        setNavBarColor()
        setLogoNav()
        setButonsNav()
        fetchNotifications()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchNotifications), for: .valueChanged)
    }
    
    
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: BaseNotificationsTableViewCell.self)
        tableView.registerCellNib(cellClass: FriendsNotificationsTableViewCell.self)
        tableView.registerCellNib(cellClass: MangmentTableViewCell.self)
    }
    
    @IBAction func waitingFriendRequest(_ sender: Any) {
        let vc = WaitingFriendViewController()
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}

extension NotificationTabBarViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let notificationKey = arrNotification[indexPath.row].key else {return UITableViewCell()}
        
        if notificationKey == "new_friend_request" {
            let cell = tableView.dequeue() as FriendsNotificationsTableViewCell
            let data = arrNotification[indexPath.row]
            cell.dataItem = data
            cell.delegate = self
            return cell
        }else if notificationKey == "management_message" {
            let cell = tableView.dequeue() as MangmentTableViewCell
            let data = arrNotification[indexPath.row]
            cell.dataItem = data
            return cell
        }else{
            let cell = tableView.dequeue() as BaseNotificationsTableViewCell
            let data = arrNotification[indexPath.row]
            cell.dataItem = data
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let notificationKey = arrNotification[indexPath.row].key ?? ""
        
        if  notificationKey == "new_friend_request" {
            return 130
            
        }else {
            return  100
        }
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNotification(index: indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if arrNotification.count < 4 {
            return
        }
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        let topOffset = CGPoint(x: 0, y: 0)
        
        if scrollView.contentOffset.y >= bottomOffset.y {
            
            hideHomeViewButtons()
            return
        } else if scrollView.contentOffset.y <= topOffset.y { // top
            showHomeViewButtons()
            return
        }
        
        if lastContentOffset > scrollView.contentOffset.y {
            showHomeViewButtons()
        } else if lastContentOffset < scrollView.contentOffset.y, scrollView.contentOffset.y > 60 {
            hideHomeViewButtons()
        }
        lastContentOffset = scrollView.contentOffset.y
    }
    
    private func hideHomeViewButtons() {
        guard !isShowBarButtons else { return }
        UIView.animate(withDuration: 0.5) {
            self.topSV.transform = .init(translationX: 0, y: -250)
        }
        topSV.isHidden = true
        isShowBarButtons = true
    }
    private func showHomeViewButtons() {
        guard isShowBarButtons else { return }
        UIView.animate(withDuration: 0.5) {
            self.topSV.transform = .identity
        }
        isShowBarButtons = false
        topSV.isHidden = false
    }
}

extension NotificationTabBarViewController: FriendsNotificationsDelegate {
    func acceptButtonTapped(cell: FriendsNotificationsTableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        let userId = arrNotification[index].senderData?.id ?? 0
        
        repo.request(BaseModelWith<UserData>.self, FriendsRequestRouter.acceptFriendRequest(id: userId)) {[weak self] (data) in
            guard self != nil else {return}
            self?.deleteNotification(index: index)
        }
    }
    
    func cancelButtonTapped(cell: FriendsNotificationsTableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        let userId = arrNotification[index].senderData?.id ?? 0
        
        repo.request(BaseModelWith<UserData>.self, FriendsRequestRouter.rejectFriendRequest(id: userId)) {[weak self] (data) in
            guard self != nil else {return}
            self?.deleteNotification(index: index)
        }
    }
    
    private func deleteNotification(index: Int) {
        guard let id = arrNotification[index].id else {return}
        repo.request(BaseModel.self, NotificationRouter.deleteNotification(id: id)) { [weak self] (response) in
            self?.deleteRow(index: index)
        }
    }
    
    private func deleteRow(index: Int) {
        arrNotification.remove(at: index)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.endUpdates()
    }
}
//NotificationDataModel
extension NotificationTabBarViewController {
 @objc private func fetchNotifications() {
        repo.request(NotificationDataModel.self, NotificationRouter.fetchNotification) { [weak self] (response) in
            guard let data = response?.data else {return}
            self?.countFriendsRequest()
            self?.refreshControl.endRefreshing()
            self?.arrNotification = data
            self?.tableView.reloadData()
        }
    }
    
    private func countFriendsRequest() {
      let count =  arrNotification.filter({$0.key == NotificationKeys.friendRequest.rawValue}).count
        countFriendLbl.text = String(count)
    }
}
