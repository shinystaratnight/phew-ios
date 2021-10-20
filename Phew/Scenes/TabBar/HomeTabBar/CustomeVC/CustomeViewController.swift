//
//  CustomeViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/3/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit


class CustomeViewController: BaseViewController {
    
    @IBOutlet weak var btnFriendsOutlet: UIButton!
    @IBOutlet weak var btnAllPostsOutlet: UIButton!
    @IBOutlet weak var viewHomeButtons: UIView!
    @IBOutlet weak var tableView: UITableView!

    private var presenter:HomePresenterProtocol!
    private var isHomeButtonsHidden = false
    private var refreshControl = UIRefreshControl()
    private var user: User?
    private var hasUserProfile = 0
    private var typePost = "normal"
    var arrHome = [HomeModelType]()
    private var isLoading: Bool = false
    private var lastPage: Int?
    private var current: Int = 1
    private var postsVCsType = PostsVCs.home
    
    private var cellHeights = [IndexPath: CGFloat]()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var lastContentOffset: CGFloat = 0
    var isShowBarButtons: Bool = false
    var postType: PostType! = .global {
        didSet{
            feachHomeData(showIndicator: true)
        }
    }
    
    var featchHome: Bool = true{
        didSet {
            feachHomeData(showIndicator: false)
        }
    }
    private var cellEditHeiht: NSLayoutYAxisAnchor!
    
    lazy  private var viewEditPost: UIView = {
        let v  = UIView()
        v.withSize(CGSize(width: 150, height: 75))
        v.layer.cornerRadius = 10
        return v
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user == nil {
            feachHomeData(showIndicator: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
//        loadData()
        presenter = HomePresenter(viewWidth: tableView.bounds.width)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        initScreenShot()
        btnFriendsOutlet.tintColor = .mainGray
        
        self.btnAllPostsOutlet.setImage(UIImage(named: "friends")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func loadData() {
        switch postsVCsType {
        case .home:
            NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadHomeData, object: nil)
            feachHomeData(showIndicator: true)
            viewHomeButtons.isHidden = false
        case .userProfile:
            feacthUserPosts(type: "normal", isShowIndicator: true)
            viewHomeButtons.isHidden = true
        case .findaly(let countryId, let cityId):
            featchFindlyPosts(cityId: cityId, countryId: countryId, showIndicator: true)
            viewHomeButtons.isHidden = true
        }
    }
    lazy private var isHideiewEditPost: Bool = true  {
        didSet{
            if isHideiewEditPost {
                viewEditPost.removeFromSuperview()
            }else {
                view.addSubview(viewEditPost)
                viewEditPost.layer.cornerRadius = 10
                viewEditPost.trailingAnchorSuperView(constant: 20)
                viewEditPost.topAnchorToView(anchor: cellEditHeiht, constant: 5)
            }
        }
    }
    
    init(user: User?, type: PostsVCs) {
        self.user = user
        self.postsVCsType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refreshData() {
        switch postsVCsType {
        case .home:
            feachHomeData(showIndicator: false)
        case .userProfile:
            feacthUserPosts(type: typePost, isShowIndicator: false)
        case .findaly(countryId: let countryId, cityId: let cityId):
            featchFindlyPosts(cityId: cityId, countryId: countryId, showIndicator: false)
        }
    }
    
    @objc private func reloadData() {
        feachHomeData(showIndicator: false)
        isHideiewEditPost = true
    }
    
    private
    func registerTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .none
        tableView.registerCellNib(cellClass: MainPostTableViewCell.self)
        tableView.registerCellNib(cellClass: SharePostTableViewCell.self)
        tableView.registerCellNib(cellClass: ShareTextPostTableViewCell.self)
        tableView.registerCellNib(cellClass: LocationPostTableViewCell.self)
        tableView.registerCellNib(cellClass: SharePostLocationTableViewCell.self)
        tableView.registerCellNib(cellClass: WatchingPostUItabviewCell.self)
        tableView.registerCellNib(cellClass: SharepostWatchingTableViewCell.self)
        //
        tableView.registerCellNib(cellClass: SponsorTableViewCell.self)
        tableView.registerCellNib(cellClass: SecretMessagePostTableViewCell.self)
        if let _ = user {
            tableView.registerCellNib(cellClass: UserInformationHeaderTableViewCell.self)
            hasUserProfile = 1
        }
    }
    
    @IBAction func btnFriendsTapped(_ sender: UIButton) {
        btnAllPostsOutlet.tintColor = .mainGray
        postType = .friends
        sender.setImage(nil, for: .normal)
        
        sender.setTitleColor(.mainGreen, for: .normal)
        sender.titleLabel?.font = UIFont.tahomaBold(15)
        sender.setTitle("Friends".localize, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.setImage(#imageLiteral(resourceName: "friends-in"), for: .normal)
            sender.tintColor = .mainGreen
            sender.setTitle(nil, for: .normal)
        }
    }
    
    @IBAction func btnAllPostsTapped(_ sender: UIButton) {
        btnFriendsOutlet.tintColor = .mainGray
        postType = .global
        
        sender.setImage(nil, for: .normal)
        
        sender.setTitleColor(.mainColor, for: .normal)
        sender.titleLabel?.font = UIFont.tahomaBold(15)
        sender.setTitle("All".localize, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.setImage(UIImage(named: "friends")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.tintColor = .mainColor
            sender.setTitle(nil, for: .normal)
        }
    }
}

extension CustomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHome.count + hasUserProfile
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isHideiewEditPost = true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let _user = user, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInformationHeaderTableViewCell", for: indexPath) as! UserInformationHeaderTableViewCell
            cell.item = _user
            cell.deleget = self
            return cell
        }else {
            let index = indexPath.row - hasUserProfile
            let postType = arrHome[index].data?.postType ?? ""
            let activity =  arrHome[index].data?.activityType ?? ""
            let postableType = arrHome[index].data?.postableType ?? ""
            let cellType = presenter.getCellType(postType: postType, activityType: activity, activityTypeShare: arrHome[index].data?.postable?.activityType, type: arrHome[index].type ?? "", postableType: postableType)
            
            switch cellType {
            case .normal:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "MainPostTableViewCell", for: indexPath) as! MainPostTableViewCell
                cell.deleget = self
                cell.item = arrHome[index].data
                return cell
            case .location:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "LocationPostTableViewCell", for: indexPath) as! LocationPostTableViewCell
                cell.item = arrHome[index].data
                cell.delegate = self
                return cell
            case .watching:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "WatchingPostUItabviewCell", for: indexPath) as! WatchingPostUItabviewCell
                cell.item = arrHome[index].data
                cell.delegate = self
                return cell
            case .sharePost:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "SharePostTableViewCell", for: indexPath) as! SharePostTableViewCell
                cell.item = arrHome[index].data
                cell.delegate = self
                return cell
            case .ShareText:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTextPostTableViewCell", for: indexPath) as! ShareTextPostTableViewCell
                cell.item = arrHome[index].data
                cell.delegate = self
                return cell
            case .shareLocation:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "SharePostLocationTableViewCell", for: indexPath) as! SharePostLocationTableViewCell
                cell.item = arrHome[index].data
                cell.delegate = self
                return cell
            case .shareWatch:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "SharepostWatchingTableViewCell", for: indexPath) as! SharepostWatchingTableViewCell
                cell.item = arrHome[index].data
                cell.delegate = self
                return cell
            case .sponsor:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "SponsorTableViewCell", for: indexPath) as! SponsorTableViewCell
                cell.delegate = self
                cell.item = arrHome[index].data
                return cell
            case .secretMessage:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SecretMessagePostTableViewCell", for: indexPath) as! SecretMessagePostTableViewCell
                cell.item = arrHome[index].data
                cell.deleget = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = user, indexPath.row == 0 {
            return 250
        }else{
            let post = arrHome[indexPath.row - hasUserProfile]
            if post.type == HomeDataTypeEnum.sponsor.rawValue {
                return 230
            }else {
                guard let model =  post.data else{return 0.0}
                return  presenter.getCellHeight(model: model, activityTypeShare: arrHome[indexPath.row - hasUserProfile].data?.postable?.activityType, type: post.type ?? "", isFullPost: false)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = user, indexPath.row == 0{
        }else{
            if let type = arrHome[indexPath.row].type, type == HomeDataTypeEnum.sponsor.rawValue {
                if let typeSponser = arrHome[indexPath.row].data?.type, typeSponser == "video" {
                    presentModelyVC(PalyVideoViewController(vedioUrl: arrHome[indexPath.row].data?.file ?? ""))
                }
            }else{
                let post = arrHome[indexPath.row - hasUserProfile]
                guard var model = post.data else {return}
                model.isShowFullPost = true
                let data = presenter.getPostType(post: &model ,type: post.type ?? "", isFullPost: true)
                push(ShowPostViewController(postId: data.postId, postType: data.postType, post: data.post, cellHeight: data.height))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height

        if  Pagenation.canPagenat(isLoading: isLoading, lastPage: lastPage, current: current, index: indexPath.row, count: arrHome.count) {
            switch postsVCsType {
            case .home:
                featchHomeDataPagenation()
            case .userProfile:
                feacthUserPostsPagenation(isShowIndicator: false)
            case .findaly(countryId: let countryId, cityId: let cityId):
                featchFindlyPostsPagenation(cityId: cityId, countryId: countryId, showIndicator: false)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard postsVCsType == .home, arrHome.count > 4  else {return}
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
        guard !isHomeButtonsHidden else { return }
        UIView.animate(withDuration: 0.5) {
            self.viewHomeButtons.transform = .init(translationX: 0, y: -250)
        }
        viewHomeButtons.isHidden = true
        isHomeButtonsHidden = true
    }
    private func showHomeViewButtons() {
        guard isHomeButtonsHidden else { return }
        UIView.animate(withDuration: 0.5) {
            self.viewHomeButtons.transform = .identity
        }
        isHomeButtonsHidden = false
        viewHomeButtons.isHidden = false
    }
}

extension CustomeViewController{
    private func feachHomeData(showIndicator:Bool){
        if let _ = user {
            feacthUserPosts(type: "normal")
        }else{
            let type = postType == .friends ? "friends" : "all"
            repo.request(HomeData.self, CoreRouter.home(type: type, page: 1), showLoader: showIndicator) { [weak self](response) in
                self?.refreshControl.endRefreshing()
                guard let data = response?.data else{return}
                self?.arrHome = data
                guard let meta = response?.meta else{return}
                self?.lastPage = meta.lastPage
                self?.current = meta.currentPage ?? 1
                self?.tableView.reloadData()
            }
        }
    }
    
    private func featchHomeDataPagenation(){
        isLoading = true
        let type = postType == .friends ? "friends" : "all"
        repo.request(HomeData.self, CoreRouter.home(type: type, page: (current + 1)), showLoader: false) { [weak self](response) in
            guard let self = self else {return}
            guard let data = response?.data else{return}
            guard let meta = response?.meta else{return}
            self.lastPage = meta.lastPage
            self.current = meta.currentPage ?? 1
            self.arrHome.append(contentsOf: data)
            self.tableView.reloadData()
            self.isLoading = false
        }
    }
    
    private func fav(postId: Int) {
        repo.request(BaseModelWith<FavPostModel>.self, CoreRouter.favourit(postId: postId)) { [weak self](response) in
            guard let isFav = response?.data?.isFav else{return}
            guard let index = self?.getIndex(postId: postId) else{return}
            self?.arrHome[index].data?.isFav = isFav
            self?.cellFav(index: index, isfav: isFav)
        }
    }
    
    private func relodCell(index: Int) {
        let reloadIndex = index + hasUserProfile
        print(reloadIndex)
        tableView.reloadRows(at: [IndexPath(row: reloadIndex, section: 0)], with: .none)
    }
    
    private func cellFav(index: Int, isfav: Bool) {
        if let _ = user, isfav == false {
            arrHome.remove(at: index)
            tableView.reloadData()
        }else {
            relodCell(index: index)
        }
    }
    
    private func getIndex(postId: Int) -> Int?  {
        guard let index = arrHome.firstIndex(where: {$0.data?.id == postId}) else {return nil}
        return index
    }
    
    private func reactPost(postId: Int, type: String?) {
        repo.request(BaseModelWith<LikePostModel>.self, CoreRouter.like(postId: postId, type: type), showLoader: true) { [weak self](response) in
            guard (response?.data) != nil else{return}
            guard let index = self?.getIndex(postId: postId) else{return}
            
            self?.repo.request(BaseModelWith<HomeModel>.self, CoreRouter.getPost(postId: postId)) {(response) in
                guard let data = response?.data else{return}
                print(data)
                self?.arrHome[index].data = data
                self?.relodCell(index: index)
            }
        }
    }
    
    private func feacthUserPosts(type: String, isShowIndicator: Bool = true) {
        guard let userId = user?.id else {return}
        arrHome.removeAll()
        tableView.reloadData()
        repo.request(HomeData.self, ProfileRouter.posts(userId: userId, type: type, page: 1), showLoader: isShowIndicator) { [weak self](response) in
            self?.refreshControl.endRefreshing()
            guard let data = response?.data else{return}
            guard let meta = response?.meta else{return}
            self?.lastPage = meta.lastPage
            self?.current = meta.currentPage ?? 1
            self?.arrHome = data
            self?.tableView.reloadData()
        }
    }
    
    private func feacthUserPostsPagenation(isShowIndicator: Bool = true) {
        guard let userId = user?.id else {return}
        repo.request(HomeData.self, ProfileRouter.posts(userId: userId, type: typePost, page: (current + 1)), showLoader: isShowIndicator) { [weak self](response) in
            self?.refreshControl.endRefreshing()
            guard let data = response?.data else{return}
            guard let meta = response?.meta else{return}
            self?.lastPage = meta.lastPage
            self?.current = meta.currentPage ?? 1
            self?.arrHome.append(contentsOf: data)
            self?.tableView.reloadData()
        }
    }
    
    private func featchFindlyPosts(cityId: Int, countryId: Int, showIndicator: Bool) {
        repo.request(HomeData.self, FindalyRouter.posts(countryId: countryId, cityId: cityId, page: 1), showLoader: showIndicator) { [weak self](response) in
            self?.refreshControl.endRefreshing()
            guard let data = response?.data else{return}
            guard let meta = response?.meta else{return}
            self?.lastPage = meta.lastPage
            self?.current = meta.currentPage ?? 1
            self?.arrHome = data
            self?.tableView.reloadData()
        }
    }
    
    private func featchFindlyPostsPagenation(cityId: Int, countryId: Int, showIndicator: Bool) {
        repo.request(HomeData.self, FindalyRouter.posts(countryId: countryId, cityId: cityId, page: (current + 1)), showLoader: showIndicator) { [weak self](response) in
            self?.refreshControl.endRefreshing()
            guard let data = response?.data else{return}
            guard let meta = response?.meta else{return}
            self?.lastPage = meta.lastPage
            self?.current = meta.currentPage ?? 1
            self?.arrHome.append(contentsOf: data)
            self?.tableView.reloadData()
        }
    }
    
    private func initScreenShot() {
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) {[weak self] notification in
            self?.sendPosttakedScreen()
        }
    }
    private func sendPosttakedScreen() {
        let postId = getCurrentCellIndex()
        repo.request(BaseModel.self, CoreRouter.screenShot(postId: postId)) { (_) in
            
        }
    }
    private func getCurrentCellIndex() -> String{
        guard arrHome.count > 0 else {return ""}
        let cells = tableView.visibleCells.filter {
            !($0 is UserInformationHeaderTableViewCell)
        }
        
        //tableView.indexPath(for: $0)?.row ?? 0)
        let arrIndeces =  cells.map { (cell) -> Int in
            var index = tableView.indexPath(for: cell)?.row ?? 0
            if user != nil {
               index -= 1
            }
            return index
        }
        var arrIds = [String]()
//        guard arrIndeces.count > 0 else {return}
        arrIndeces.forEach({
            let post = arrHome[$0]
            if post.type == HomeDataTypeEnum.post.rawValue {
                let id = post.data?.id
                arrIds.append(String(id ?? 0))
            }
        })
        var value = "["
        arrIds.forEach({
            value +=  String($0)
            value += ","
        })
        value =  String(value.dropLast())
        value += "]"
        
        return  value
    }
}

extension CustomeViewController:HomeCellsProtocol{
    
    func didTappedUserImage<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        guard let id = post.data?.user?.id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
    
    func didTappedUserImageReplay<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        guard let post = arrHome[index.row - hasUserProfile].data else {return}
        guard let id = post.postable?.user?.id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
    
    func didTappedLike<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        guard let post = arrHome[index.row - hasUserProfile].data else {return}
        guard let postId = post.id else{return}
        if let _ = post.likeType {
            reactPost(postId: postId, type: nil)
        }else {
            reactPost(postId: postId, type: Helper.getNameReact(tag: 0))
        }
    }
    
    func didTappedRact(reactType: String, postId: Int) {
        reactPost(postId: postId, type: reactType)
    }
    
    func didTappedWashlist<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell)?.row else{return}
        guard let postId = arrHome[index - hasUserProfile].data?.id else {return}
        fav(postId: postId)
    }
    
    func didTappedShare<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell)?.row else{return}
        let model = arrHome[index - hasUserProfile]
        guard var post = model.data else {return}
        let data = presenter.getPostShare(post: &post, type: model.type ?? "")
        
        showAlert(postId: data.postId, post:data.post, cellHeight: data.height, type: model.type ?? ""  )
    }
    
    func didTappedAllFrinds<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        guard let frinends = post.data?.mentions else {return}
        push(ShowAllFriendsViewController(friends: frinends))
    }
    
    func didSelectMedia<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        var arrPostNormal = [HomePostNormalViewModel]()
        arrPostNormal =  Helper.getArrayMedia(arrVideos: post.data?.videos, arrImages: post.data?.images)
        presentModelyVC(PostSliderViewController(arrPosts: arrPostNormal))
    }
    
    func didSelectMediaRplay<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        var arrPostNormal = [HomePostNormalViewModel]()
        arrPostNormal =  Helper.getArrayMedia(arrVideos: post.data?.postable?.videos, arrImages: post.data?.postable?.images)
        presentModelyVC(PostSliderViewController(arrPosts: arrPostNormal))
        
    }
    func didTappedFirstFrinds<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        guard let id = post.data?.mentions?.first?.id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
    
    func didTappedShowPost<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell)?.row else{return}
        let model = arrHome[index - hasUserProfile]
        guard var post =  model.data else {return}
        var data = presenter.getPostType(post: &post, type: model.type ?? "", isFullPost: true )
        data.post.isShowFullPost = true
        push(ShowPostViewController(postId: data.postId, postType: data.postType, post: data.post, cellHeight: data.height))
    }
    
    func didTappedShowReplay<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell)?.row else{return}
        let model = arrHome[index - hasUserProfile]
        guard var post = model.data else {return}
        var data = presenter.getPostType(post: &post, type: model.type ?? "", isFullPost: true)
        data.post.isShowFullPost = true
        push(ShowPostViewController(postId: data.postId, postType: data.postType, post: data.post, cellHeight: data.height))
    }
    func didTappedFirstFrindsReplay<T:UITableViewCell>(cell:T){
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        guard let id = post.data?.postable?.mentions?.first?.id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
    func didTappedAllFrindsReplay<T:UITableViewCell>(cell:T){
        guard let index = tableView.indexPath(for: cell) else{return}
        let post = arrHome[index.row - hasUserProfile]
        guard let frinends = post.data?.postable?.mentions else {return}
        push(ShowAllFriendsViewController(friends: frinends))
    }
    
    func didTappedShowUserTakeScreens(postId: Int) {
        guard let index = arrHome.firstIndex(where: {$0.data?.id == postId}) else {return}
        guard let frinends  = arrHome[index].data?.screenShots else {return}
        presentModelyVC(FriendsTakeScreenShotViewController(users: frinends))
    }
    
    func didTappedOwnerEditPost(postId: Int, topAnchor: NSLayoutYAxisAnchor) {
        cellEditHeiht = topAnchor
        isHideiewEditPost.toggle()
        guard let post = arrHome.filter({$0.data?.id == postId}).first?.data else {return}
        let type = self.presenter.getCellType(postType: post.postType ?? "", activityType: post.activityType ?? "", activityTypeShare: nil, type: post.type ?? "", postableType: post.postableType ?? "")
        let vc = OwnerWorkWithPostViewController(post: post, type: type)
        guard let index = self.arrHome.firstIndex(where: {$0.data?.id == postId}) else {return}
        vc.didMakeAction = { [weak self] type in
            switch type {
            case .delete:
                self?.isHideiewEditPost = true
                self?.deletePost(index: index)
            case .edit:
                self?.isHideiewEditPost = true
            case .findaly:
                self?.isHideiewEditPost = true
            case .policy:
                self?.isHideiewEditPost = true
            }
        }
        if isHideiewEditPost == false {
            addChildViewController(childViewController: vc, childViewControllerContainer: viewEditPost)
        }
    }
    func didTappedDeleteAdv<T>(cell: T) where T : UITableViewCell {
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        guard let id = arrHome[index].data?.id else {return}
        deleteAdv(id: id)
        deletePost(index: index)
    }
    
    private func deletePost(index: Int) {
        arrHome.remove(at: index)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .fade)
        tableView.endUpdates()
    }
}
extension CustomeViewController{
    private func showAlert(postId:Int, post:HomeModel, cellHeight:CGFloat, type: String)  {
        let alert = UIAlertController(title: "Share".localized, message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Echo Now".localized, style: .default, handler: { (_) in
            self.shareWithouComment(postId: postId)
        }))
        alert.addAction(UIAlertAction(title: "Echo With Comment".localized, style: .default, handler: { (_) in
            let _type =  self.presenter.getCellType(postType: post.postType ?? "", activityType: post.activityType ?? "", activityTypeShare: nil, type: type, postableType: post.postableType ?? "")
            let vc  = SharePostViewController(postId: postId, postType: _type, post: post, cellHeight:cellHeight)
            vc.deleget = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc.toNavigation, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true)
    }
    private func shareWithouComment(postId:Int){
        let type = postType == .friends ? "friends" : "all"
        
        repo.request(PostModel.self, CoreRouter.shareWithoutComment(postId: postId, privacy: type)) { [weak self](response) in
            self?.feachHomeData(showIndicator: true)
        }
    }
    
    private func deleteAdv(id: Int) {
        repo.request(BaseModel.self, CoreRouter.hideAdv(id: id)) {(_) in
        }
    }
    
}

extension CustomeViewController :UserInformationHeaderTableViewCellProtocol {
    func didTappedProfileSlider(profile images: [HomePostNormalViewModel]) {
        presentModelyVC( PostSliderViewController(arrPosts: images))
    }
    
    func didTappedCancelFriendRequest(userId: Int) {
        repo.request(BaseModel.self, FriendsRequestRouter.cancelFriendRequest(id: userId)) { [weak self] (_) in
            self?.user?.isFriendRequest = false
            self?.user?.senderFriendRequest = nil
            self?.reloadUserCell()
        }
    }
    
    func didTappedRejectFriendRequest(userId: Int) {
        repo.request(BaseModel.self, FriendsRequestRouter.rejectFriendRequest(id: userId)) {[weak self] (_) in
            self?.user?.isFriendRequest = false
            self?.user?.senderFriendRequest = nil
            self?.reloadUserCell()
        }
    }
    
    func didTappedAcceptFriendRequest(userId: Int) {
        repo.request(BaseModel.self, FriendsRequestRouter.acceptFriendRequest(id: userId)) { [weak self](_) in
            self?.user?.isFriendRequest = false
            self?.user?.isFriend = true
            self?.user?.senderFriendRequest = nil
            self?.reloadUserCell()
        }
    }
    
    func didTappedRemoveFriendRequest(userId: Int) {
        repo.request(BaseModel.self, FriendsRouter.removeRequest(id: userId)) { [weak self] (_) in
            self?.user?.isFriend = false
            self?.user?.isFriendRequest = false
            self?.user?.senderFriendRequest = nil
            self?.reloadUserCell()
        }
    }
    
    func chatWithUser(userId: Int) {
        push(ChatViewController(messageId: userId))
    }
    
    func showMessages() {
        push(MessagesTabBarViewController(isPush: true))
    }
    
    func didTappedAddFriend(userId: Int) {
        repo.request(BaseModel.self, FriendsRequestRouter.sendFriendRequest(id: userId)) { [weak self] (_) in
            self?.user?.isFriendRequest = true
            self?.user?.senderFriendRequest = "me"
            self?.reloadUserCell()
            
        }
    }
    private func reloadUserCell() {
        self.tableView.performBatchUpdates() { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }

    }
    
    func didTappedFollowFriend(userId: Int) {
        repo.request(BaseModelWith<FollowFriendModel>.self, FollowtRouter.followUnFollow(id: userId)) { [weak self] (response) in
            guard let isFollow = response?.data?.isFollow else {return}
            self?.user?.isFollow = isFollow
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    func didTappedSecretQuestion(userId: Int) {
        let vc = SecretMessageViewController(userId: userId).toNavigation
        presentModelyVC(vc)
    }
    
    func showAllFriends() {
        push(MyFriendsViewController())
    }
    
    func didTappedNormal() {
        typePost = "normal"
        feacthUserPosts(type: typePost)
    }
    
    func didTappedLocation() {
        typePost = "location"
        feacthUserPosts(type: typePost )
    }
    
    func didTappedWatching() {
        typePost = "watching"
        feacthUserPosts(type: typePost)
    }
    
    func didTappedFavourit() {
        typePost = "fav"
        feacthUserPosts(type: typePost)
    }
}

extension CustomeViewController: AddNewPostProtocol{
    func didAddNewPost() {
        feachHomeData(showIndicator: false)
        
    }
}
