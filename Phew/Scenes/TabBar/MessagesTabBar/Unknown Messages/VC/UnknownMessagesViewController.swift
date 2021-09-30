//
//  UnknownMessagesViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 12/23/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class UnknownMessagesViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    private var arrMessages = [SectertMessages]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        featchMessages(showLoader: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableview()
        featchMessages(showLoader: true)
    }
}


extension UnknownMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func initTableview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerCellNib(cellClass: UnknowMessagesTableViewCell.self)
        tableview.rowHeight = 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "UnknowMessagesTableViewCell", for: indexPath) as! UnknowMessagesTableViewCell
            cell.item = arrMessages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(ReplySecretMessageViewController(message: arrMessages[indexPath.row]))
    }
}

extension UnknownMessagesViewController {
    private func featchMessages(showLoader: Bool) {
        repo.request(SectertMessagesData.self, SecretMessageRouter.list, showLoader: showLoader) { [weak self] (response) in
            guard let data = response?.data else {return}
            guard let self = self else {return}
            self.arrMessages = data
            self.tableview.reloadData()
        }
    }
}

