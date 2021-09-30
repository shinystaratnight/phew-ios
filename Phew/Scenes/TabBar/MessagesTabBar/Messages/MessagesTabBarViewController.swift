//
//  MessagesTabBarViewController.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class MessagesTabBarViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var arrConversation = [ConversationModel]()
    private var isPush = false
    private var refresh = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        featchConversation()
        clearNavigationBackButtonTitle()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(featchConversation), for: .valueChanged)
    }
    
    init(isPush: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isPush = isPush
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private
    func updateView() {
        if !isPush {
            setLogoNav()
            setButonsNav()
        }
        registerTableView()
//        trasperantNavBar()
        setNavBarColor()
    }
    
    @IBAction func btnUnknowMessagesTapped(_ sender: Any) {
        push(UnknownMessagesViewController())
    }
    private func registerTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: MessagesTableViewCell.self)
    }
}

extension MessagesTabBarViewController : UITableViewDelegate , UITableViewDataSource {
    
    //MARK:- TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrConversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as MessagesTableViewCell
        cell.item = arrConversation[indexPath.row]
        return cell
    }
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = arrConversation[indexPath.row].otherUserData?.id else {return}
        push(ChatViewController(messageId: id))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MessagesTabBarViewController {
  @objc  private func featchConversation() {
        repo.request(BaseModelWith<[ConversationModel]>.self, ChatRouter.conversation) { [weak self] (response) in
            self?.refresh.endRefreshing()
            guard let data = response?.data else {return}
            self?.arrConversation = data
            self?.tableView.reloadData()
        }
    }
}
