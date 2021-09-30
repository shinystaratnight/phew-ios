//
//  PostWatchViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/17/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class PostWatchViewController: BaseViewController, UITextFieldDelegate {
    
    
//    @IBOutlet weak var txtSearchFiends: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFilmYear: UILabel!
    @IBOutlet weak var lblFilmName: UILabel!
    @IBOutlet weak var imageUser: CircleImageView!
    @IBOutlet weak var collctionViewFirends: UICollectionView!
    
    var didAddPostWatch:(()->Void)?
    private var privacy = "all"
    private var arrUser:[User] = []
    private var arrSelectedUser: [User] = []{
        didSet{
            collctionViewFirends.reloadData()
        }
    }
    
    lazy private var tablviewFriends : UITableView = {
        
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.withHeight(200)
        tableView.withWidth(350)
        tableView.rowHeight = 40
        return tableView
    }()
    lazy private var btnHideTableView : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mainColor
        btn.setTitle("X", for: .normal)
        btn.withWidth(20)
        btn.withHeight(20)
        btn.layer.cornerRadius = 10
        return btn
    }()
    private var film:MoviFilm
    private var isHideTablviewFirnds :Bool = true {
        didSet {
            tablviewFriends.isHidden = isHideTablviewFirnds
            btnHideTableView.isHidden = isHideTablviewFirnds
           
        }
    }
    init(film:MoviFilm) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Post Watching"
        clearNavigationBackButtonTitle()
       
//        navigationController?.navigationBar.barTintColor = .mainColor
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = .white
        updateUIdata()
        
        setTabviewViewFriends()
        setButtonHidetableview()
        txtDidChanged()
        
        iniTableview()
        iniCollectionView()
    }
    
    private func updateUIdata(){
        imageUser.load(with: AuthService.userData?.profileImage)
        lblUserName.text = AuthService.userData?.fullname
        lblFilmName.text = film.title
        lblFilmYear.text = "RIDER ".localize + (film.releaseDate ?? "")
    }
    
    private func setTabviewViewFriends(){
        view.addSubview(tablviewFriends)
        tablviewFriends.centerXInSuperview()
//        tablviewFriends.bottomAnchorToView(anchor: txtSearchFiends.topAnchor, constant: -10)
        tablviewFriends.isHidden = true
    }
    
    private func setButtonHidetableview(){
        
        view.addSubview(btnHideTableView)
        btnHideTableView.leadingAnchorToView(anchor: tablviewFriends.leadingAnchor)
        btnHideTableView.bottomAnchorToView(anchor: tablviewFriends.topAnchor, constant: -5)
        btnHideTableView.addTarget(self, action: #selector(hideTableView), for: .touchUpInside)
        btnHideTableView.isHidden =  true
    }
    @objc private func hideTableView(){
        isHideTablviewFirnds = true
        view.endEditing(true)
    }
    
    private func txtDidChanged(){
//        txtSearchFiends.delegate = self
//        txtSearchFiends.addTarget(self, action: #selector(searchFrinds), for: .editingChanged)
    }
    
    @IBAction func btnTageFrinedsTapped(_ sender: Any) {
        let vc = ListMyFriendsViewController()
        vc.didSelectUser = { [weak self] users in
            self?.arrSelectedUser = users
        }
        presentModelyVC(vc.toNavigation)
    }
    @IBAction func btnPrivacyTapped(_ sender: Any) {
        let vc = PrivacyPostViewController()
        vc.delegate = self
        customPresent(vc)
    }
    
    @IBAction func btnPostTapped(_ sender: Any) {
        addNewPost()
    }
    @objc private func searchFrinds(){
        
//        if let txt = txtSearchFiends.text ,txt != "" {
//            isHideTablviewFirnds = false
//            featchSerarchResult(text: txt)
//
//        }else{
//            isHideTablviewFirnds = true
//        }
    }
}
extension PostWatchViewController :PrivacyPostViewDelegate{
    func friendOlnyTapped() {
        privacy = "friends"
    }
    
    func allTapped() {
        privacy = "all"
    }
}

extension PostWatchViewController:UITableViewDelegate, UITableViewDataSource{

    private func iniTableview(){
        tablviewFriends.delegate = self
        tablviewFriends.dataSource = self
        tablviewFriends.registerCellNib(cellClass: FriendNameTableViewCell.self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablviewFriends.dequeueReusableCell(withIdentifier: "FriendNameTableViewCell") as! FriendNameTableViewCell
        cell.item = arrUser[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFirend = arrUser[indexPath.row]
        
        arrUser[indexPath.row].isSelected.toggle()
        tablviewFriends.reloadRows(at: [indexPath], with: .fade)
        
        if  !arrSelectedUser.contains(where: {$0.id == selectedFirend.id}){
            arrSelectedUser.append(selectedFirend)
        }else{
            guard let index = arrSelectedUser.lastIndex(where: {$0.id == selectedFirend.id}) else{return}
            arrSelectedUser.remove(at: index)
        }
    }
    
}

extension PostWatchViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    private func iniCollectionView(){
        collctionViewFirends.delegate = self
        collctionViewFirends.dataSource = self
        collctionViewFirends.register(UINib(nibName: "FriendNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendNameCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSelectedUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collctionViewFirends.dequeueReusableCell(withReuseIdentifier: "FriendNameCollectionViewCell", for: indexPath) as! FriendNameCollectionViewCell
        cell.item = arrSelectedUser[indexPath.row]
        cell.deleget = self
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collctionViewFirends.frame.width - 5 ) / 2.1
        return CGSize(width: width, height: 20)
    }
    
    
}

extension  PostWatchViewController: FriendNameCollectionViewCellProtocol{
    func deleteFriend(cell: FriendNameCollectionViewCell) {
        guard let index = collctionViewFirends.indexPath(for: cell)?.row else{return}
        guard let indexUser = arrUser.firstIndex(where: {$0.id == arrSelectedUser[index].id }) else{return}
        arrUser[indexUser].isSelected = false
        tablviewFriends.reloadData()
        arrSelectedUser.remove(at: index)
    }
    
}
extension  PostWatchViewController{
    
    private func convertModelToString()->String?{
        do{
        let data = try JSONEncoder().encode(film)
        let jsonString = String(data: data, encoding: .utf8)!
            return jsonString
        }catch {
            print(error)
            return nil
        }
    }
    private func addNewPost(){
        guard  let watch = convertModelToString() else{return}
        
        var friendsIds:String?
        let friendsIdsArr = arrSelectedUser.map({String($0.id ?? 0)})
        if friendsIdsArr.count > 0 {
            friendsIds = "\(friendsIdsArr)"
        }
       
        repo.request(PostModel.self, CoreRouter.postWatch(watching: watch, firends: friendsIds, privacy: privacy)) { [weak self](response) in
            self?.didAddPostWatch?()
            self?.popMe(after: 1)
        }
    }
    
    private func featchSerarchResult(text:String){
        repo.request(BaseModelWith<[User]>.self, CoreRouter.searchFriends(text: text)) { [weak self](response) in
            
            guard let self = self else{return}
            guard let arr = response?.data else{return}
   
            DispatchQueue.main.async {
                self.arrUser = arr
                self.tablviewFriends.reloadData()
                if self.arrSelectedUser.count > 0{
                
                for item in self.arrSelectedUser {
    
                    self.arrUser.forEach({
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
                    self.arrUser.forEach({$0.isSelected = false})
                }
                self.tablviewFriends.reloadData()
                
            }
        }
        
    }

}


