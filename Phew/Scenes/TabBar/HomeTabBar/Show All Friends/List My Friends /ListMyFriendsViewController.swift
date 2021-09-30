//
//  ListMyFriendsViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 3/14/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class ListMyFriendsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var arrFriends: [User] = []
    private var searchBar =  UISearchBar()
    private var arrSelectedUser: [User] = []
    private var filerArr: [User] = []
    var didSelectUser: (([User])->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        iniTableview()
        listMyFriends()
        setSearchBar()
    }
    let btnDone: UIButton = UIButton()
        .withHeight(40) as! UIButton
    
    private func setSearchBar() {
        btnDone.setTitle("Done".localize, for: .normal)
        navigationItem.rightBarButtonItems = [ .init(customView: btnDone)]
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        tableView.keyboardDismissMode = .onDrag
        btnDone.addTarget(self, action: #selector(setTaggedUsers), for: .touchUpInside)
    }
    
    @objc private  func setTaggedUsers() {
        didSelectUser?(arrSelectedUser)
        dismissMePlease()
    }
}

extension ListMyFriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter =  arrFriends.filter({($0.fullname?.lowercased().contains(searchText.lowercased()) ?? false)}).map({$0})
        filerArr = filter
        if searchText.isEmpty {
            filerArr = arrFriends
        }
        tableView.reloadData()
    }
}
extension ListMyFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func iniTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "FriendNameTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendNameTableViewCell"
        )
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendNameTableViewCell", for: indexPath) as! FriendNameTableViewCell
//        cell.deleget = self
        cell.item = filerArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedFirend = filerArr[indexPath.row]
        
        filerArr[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        if  !arrSelectedUser.contains(where: {$0.id == selectedFirend.id}){
            arrSelectedUser.append(selectedFirend)
        }else{
            guard let index = arrSelectedUser.lastIndex(where: {$0.id == selectedFirend.id}) else{return}
            arrSelectedUser.remove(at: index)
        }
    }
}

extension ListMyFriendsViewController {
    fileprivate func listMyFriends() {
        guard let id = AuthService.userData?.id else {return}
        repo.request(FriendsDataModel.self, FriendsRouter.listFriends(id: id)) { [weak self](response) in
            guard let data = response?.data else{return}
            let users = data.compactMap({$0.user})
            self?.arrFriends = users
//            self?.updateCountFriends()
            self?.filerArr = users
            self?.tableView.reloadData()
        }
    }
    
    private func featchSerarchResult(text:String){
        repo.request(BaseModelWith<[User]>.self, CoreRouter.searchFriends(text: text)) { [weak self](response) in
            
            guard let self = self else{return}
            guard let arr = response?.data else{return}
   
            DispatchQueue.main.async {
                self.arrFriends = arr
                self.tableView.reloadData()
                if self.arrSelectedUser.count > 0{
                
                for item in self.arrSelectedUser {
    
                    self.arrFriends.forEach({
                        if $0.id == item.id {
                            $0.isSelected = true
                        }else{
                            if !($0.isSelected ){
                                $0.isSelected = false
                            }
                        }
                    })
                }
                    
                }else{
                    self.arrFriends.forEach({$0.isSelected = false})
                }
                self.tableView.reloadData()
                
            }
        }
        
    }
}
