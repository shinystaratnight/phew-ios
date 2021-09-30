//
//  SearchViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/26/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController  {
    
    private let searchbar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    // We keep track of the pending work item as a property
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var arrUser:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearNavigationBackButtonTitle()
        navigationItem.titleView = searchbar
        searchbar.backgroundColor = .mainColor
        searchbar.delegate = self
        searchbar.endEditing(true)
        searchbar.placeholder = "Search user name".localized
        iniTableview()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    private func iniTableview(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellNib(cellClass: FriendNameTableViewCell.self)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendNameTableViewCell") as! FriendNameTableViewCell
        cell.item = arrUser[indexPath.row]
        cell.isHideSelectedUser = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = arrUser[indexPath.row].id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
}
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.featchSerarchResult(text: searchText)
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150),execute: requestWorkItem)
    }
}
extension SearchViewController {
    private func featchSerarchResult(text:String){
        repo.request(BaseModelWith<[User]>.self, CoreRouter.searchFriends(text: text)) { [weak self](response) in
            guard let self = self else{return}
            guard let arr = response?.data else{return}
            self.arrUser = arr
            self.tableView.reloadData()
        }
    }
}
