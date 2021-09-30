//
//  OwnerWorkWithPostViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/19/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class OwnerWorkWithPostViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    private var post: HomeModel
    private var type: PostEnum
    private var privacy = "all"
    var didMakeAction: ((postEditEnum)->())?
    
    private var arr = [
//        EditPostModel(name: "Edit".localize, imageName: "edit", type: .edit),
                       EditPostModel(name: "Delete".localize, imageName: "delete", type: .delete),
                       EditPostModel(name: "Findlay".localize, imageName: "findely_a", type: .findaly),
//                       EditPostModel(name: "Edit Policy".localize, imageName: "privacy_policy", type: .policy)
    ]
    
    init(post: HomeModel, type: PostEnum) {
        self.post = post
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        iniTableview()
        
        if let text = post.text, text.count > 0 {
            tableview.rowHeight = 40
        }else {
            arr.removeLast()
            tableview.rowHeight = 50
        }
    }
}

extension OwnerWorkWithPostViewController: UITableViewDelegate, UITableViewDataSource {
    private func iniTableview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 30
        tableview.registerCellNib(cellClass: OwnerWorkWithPostTableViewCell.self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "OwnerWorkWithPostTableViewCell", for: indexPath) as! OwnerWorkWithPostTableViewCell
        cell.item = arr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = arr[indexPath.row].type
    
        switch type{
        case .delete:
            deletePost()
        case .edit:
            let vc = EditPostViewController(postId: post.id ?? 0, text: post.text ?? "")
            vc.modalPresentationStyle = .formSheet
            self.present(vc.toNavigation, animated: true, completion: nil)
            break
//            didMakeAction?(.edit)
        case .findaly:
            findaly()
        case .policy:
            let vc = PrivacyPostViewController()
            vc.delegate = self
            customPresent(vc)
        }
    }
}

extension OwnerWorkWithPostViewController: PrivacyPostViewDelegate{
    func friendOlnyTapped() {
        privacy = "friends"
        updateFindlay()
    }
    
    func allTapped() {
        privacy = "all"
        updateFindlay()
    }
}
extension OwnerWorkWithPostViewController {
    private func deletePost() {
        guard let postId = post.id else {return}
        repo.request(BaseModel.self, CoreRouter.deletePost(postId: postId)) { [weak self](response) in
            if let status = response?.status, status == "true" {
                self?.didMakeAction?(.delete)
            }
        }
    }
    private func findaly() {
        guard let postId = post.id else {return}
        repo.request(BaseModel.self, CoreRouter.findaly(postid: postId)) { [weak self](response) in
            if let status = response?.status, status == "true" {
                self?.didMakeAction?(.findaly)
            }
        }
    }
    
    private func updateFindlay() {
        guard let id = post.id else {return}
        repo.request(BaseModel.self, CoreRouter.updateFindlay(postId: id, privacy: privacy)) { (_) in
        }
    }
}
