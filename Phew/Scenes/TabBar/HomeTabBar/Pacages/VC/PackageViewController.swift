//
//  PackageViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 2/21/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class PackageViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    private var id: Int?
    private var arrPackages: [PackageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniTableView()
        fetchPackages()
    }
    
    @IBAction func btnSubscribeTapped(_ sender: Any) {
        guard let _id = id else {return}
        subscribe(id: _id)
    }
}

extension PackageViewController: UITableViewDelegate, UITableViewDataSource {
    private func iniTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerCellNib(cellClass: PackagesTableViewCell.self)
        tableview.rowHeight = 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPackages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PackagesTableViewCell", for: indexPath) as! PackagesTableViewCell
        cell.item = arrPackages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrPackages.forEach({
            $0.isSelected = false
        })
        arrPackages[indexPath.row].isSelected = true
        id = arrPackages[indexPath.row].id
        tableview.reloadData()
        
    }
}
extension PackageViewController {
    private func fetchPackages() {
        repo.request(BaseModelWith<[PackageModel]>.self, GeneralRouter.packages) { [weak self] (response) in
            
            guard let arr = response?.data else {return}
            self?.arrPackages = arr
            self?.tableview.reloadData()
        }
    }
    
    private func subscribe(id: Int) {
        repo.request(BaseModelWith<UserData>.self, ProfileRouter.subscribePackage(id: id)) { [weak self] (response) in
            guard let data = response?.data else {return}
            AuthService.userData = data
            self?.popMe()
        }
    }
}
