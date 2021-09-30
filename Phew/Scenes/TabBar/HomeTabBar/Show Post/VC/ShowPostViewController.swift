//
//  ShowPostViewController.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/19/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ShowPostViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var tableViewComments: UITableView!
    private var presenter:HomePresenterProtocol!
    private var postType = PostEnum.normal
    private var postId:Int
    private var cellHeight:CGFloat
    private var post:HomeModel
    private  var viewLike: ViewLike?
    
    private var arrComment: [CommentModel] = []{
        didSet{
            tableViewComments.reloadData()
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
    lazy  private var viewEditPost: UIView = {
        let v  = UIView()
        v.backgroundColor = .backgroundCellColor
        v.withSize(CGSize(width: 150, height: 140))
        v.layer.cornerRadius = 10
        return v
    }()
    
    private var cellEditHeiht: NSLayoutYAxisAnchor!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = .backgroundCellColor
        iniTableViewPost()
        iniTableViewComment()
        featchComments()
        txtComment.delegate = self
        txtComment.returnKeyType = .send
        presenter = HomePresenter(viewWidth: view.frame.width)
    }
    
    init(postId:Int, postType:PostEnum, post:HomeModel, cellHeight:CGFloat) {
        self.postId = postId
        self.postType = postType
        self.post = post
        self.cellHeight = cellHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addComment()
        return true
    }
    @IBAction func btnPicImageTapped(_ sender: Any) {
        PhotoServices.shared.pickImageFromGalary(on: self) { [weak self](selectedImage) in
            if let image = selectedImage as? UIImage {
                let vc = MultiSelectImagesViewController(image: image)
                vc.didAddCommnet = { [weak self](arr , text) in
                    self?.addCommnet(arrImages: arr, text: text)
                }
                self?.presentModelyVC(vc)
            }
        }
    }
    
    @IBAction func btnCommentTapped(_ sender: Any) {
        addComment()
    }
    
    private func addComment() {
        guard let txt = txtComment.text, !txt.isEmpty else{
            return showAlert(with: "Enter Commnet".localize)
        }
        addCommnet(arrImages: [], text: txt)
        txtComment.text = nil
        DismissKeyboard()
    }
    
    private func iniTableViewComment(){
        tableViewComments.delegate  = self
        tableViewComments.dataSource = self
        tableViewComments.registerCellNib(cellClass: CommentTableViewCell.self)
        tableViewComments.rowHeight = 100
    }
    private func iniTableViewPost(){
        switch postType{
        case .normal:
            tableViewComments.registerCellNib(cellClass: MainPostTableViewCell.self)
        case .location:
            tableViewComments.registerCellNib(cellClass: LocationPostTableViewCell.self)
        case .watching:
            tableViewComments.registerCellNib(cellClass: WatchingPostUItabviewCell.self)
        case .sharePost:
            tableViewComments.registerCellNib(cellClass: SharePostTableViewCell.self)
        case .ShareText:
            tableViewComments.registerCellNib(cellClass: ShareTextPostTableViewCell.self)
        case .shareLocation:
            tableViewComments.registerCellNib(cellClass: SharePostLocationTableViewCell.self)
        case .shareWatch:
            tableViewComments.registerCellNib(cellClass: SharepostWatchingTableViewCell.self)
        case .sponsor:
            break
        case .secretMessage:
            tableViewComments.registerCellNib(cellClass: SharePostTableViewCell.self)
        }
    }
    private func dequesTableviewCellPost()-> UITableViewCell{
        switch postType {
        case .normal:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "MainPostTableViewCell") as! MainPostTableViewCell
            cell.item = post
            cell.lblSeeMore.isHidden = true
            cell.deleget = self
            return cell
        case .location:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "LocationPostTableViewCell") as! LocationPostTableViewCell
            cell.item = post
            cell.delegate = self
            return cell
        case .watching:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "WatchingPostUItabviewCell") as! WatchingPostUItabviewCell
            cell.item = post
            cell.delegate = self
            return cell
        case .sharePost:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "SharePostTableViewCell") as! SharePostTableViewCell
            cell.item = post
            cell.delegate = self
            //            cell.lblSeeMorePost.isHidden = true
            cell.lblSeeMoreReplyPost.isHidden = true
            return cell
            
        case .ShareText:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "ShareTextPostTableViewCell") as! ShareTextPostTableViewCell
            
            return cell
        case .shareLocation:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "SharePostLocationTableViewCell") as! SharePostLocationTableViewCell
            cell.item = post
            cell.delegate = self
            return cell
        case .shareWatch:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "SharepostWatchingTableViewCell") as! SharepostWatchingTableViewCell
            cell.item = post
            cell.delegate = self
            return cell
        case .sponsor:
            return UITableViewCell()
        case .secretMessage:
            let cell = tableViewComments.dequeueReusableCell(withIdentifier: "SharePostTableViewCell") as! SharePostTableViewCell
            cell.item = post
            cell.delegate = self
            //            cell.lblSeeMorePost.isHidden = true
            cell.lblSeeMoreReplyPost.isHidden = true
            return cell
        }
    }
}

extension ShowPostViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrComment.count == 0 {
            return 1
        }else {
            return arrComment.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewComments{
            if indexPath.row == 0 {
                return dequesTableviewCellPost()
            }else{
                let cell = tableViewComments.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as!
                    CommentTableViewCell
                cell.deleget = self
                cell.item = arrComment[indexPath.row - 1]
                return cell
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let _ = post.postable else{return}
            var model = presenter.getPostable(post: post)
            model.isShowFullPost = true
            let data = presenter.getPostType(post: &model, type: HomeDataTypeEnum.post.rawValue, isFullPost: true)
            push(ShowPostViewController(postId: data.postId, postType: data.postType, post: data.post, cellHeight: data.height))
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewComments {
            if indexPath.row == 0 {
                return cellHeight
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isHideiewEditPost = true
    }
}
extension ShowPostViewController: CommentTableViewCellProttocol {
    func didTappedCollectionImages(cell: CommentTableViewCell) {
        guard let index = tableViewComments.indexPath(for: cell) else{return}
        let comment = arrComment[index.row - 1]
        let arrPostNormal =  Helper.getArrayMedia(arrVideos: nil, arrImages: comment.images)
        presentModelyVC(PostSliderViewController(arrPosts: arrPostNormal))
    }
}

extension ShowPostViewController:HomeCellsProtocol{
    
    func didTappedUserImage<T>(cell: T) where T : UITableViewCell {
        guard let id = post.user?.id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
    
    func didTappedUserImageReplay<T>(cell: T) where T : UITableViewCell {
        guard let id = post.postable?.user?.id else {return}
        push(ShowUserProfileViewController(userId: id))
    }
    
    func didSelectMedia<T>(cell: T) where T : UITableViewCell {
        let  arrPostNormal =  Helper.getArrayMedia(arrVideos: post.videos, arrImages: post.images)
        presentModelyVC(PostSliderViewController(arrPosts: arrPostNormal))
    }
    
    func didTappedShare<T>(cell: T) where T : UITableViewCell {
        showAlert(postId: postId, post: post, cellHeight: cellHeight)
    }
    func didTappedWashlist<T>(cell: T) where T : UITableViewCell {
        guard let postId = post.id else {return}
        fav(postId: postId)
    }
    func didTappedLike<T>(cell: T) where T : UITableViewCell {
        guard let postId =  post.id else{return}
        
        if let likeType = post.likeType, likeType == Helper.getNameReact(tag: 0) {
            reactPost(postId: postId, type: nil)
        }else {
            reactPost(postId: postId, type: "like")
        }
    }
    
    func didTappedRact(reactType: String, postId: Int) {
        reactPost(postId: postId, type: reactType)
    }
    func didTappedOwnerEditPost(postId: Int, topAnchor: NSLayoutYAxisAnchor) {
        cellEditHeiht = topAnchor
        isHideiewEditPost.toggle()
        
        let vc = OwnerWorkWithPostViewController(post: post, type: postType)
        vc.didMakeAction = { [weak self] type in
            switch type {
            case .delete:
                self?.isHideiewEditPost = true
                self?.popMe()
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
}

extension ShowPostViewController{
    private func featchComments(){
        repo.request(CommentData.self, CoreRouter.listCommnet(postId: postId)) { [weak self](response) in
            guard let arr = response?.data else {return}
            self?.arrComment = arr
        }
    }
    
    private func addCommnet( arrImages:[UIImage], text:String){
        repo.upload(BaseModelWith<CommentModel>.self, CoreRouter.addCommnet(text: text, postId: postId), data: arrImages.map({UploadData(image: $0, name: "images[]")})) { [weak self](response) in
            guard let comment = response?.data else{return}
            self?.arrComment.append(comment)
        }
    }
    private func fav(postId: Int) {
        repo.request(BaseModelWith<FavPostModel>.self, CoreRouter.favourit(postId: postId)) { [weak self](response) in
            guard let isFav = response?.data?.isFav else{return}
            self?.post.isFav = isFav
            self?.relodCell()
        }
    }
    private func relodCell() {
        tableViewComments.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .middle)
    }
    private func reactPost(postId: Int, type: String?) {
        repo.request(BaseModelWith<LikePostModel>.self, CoreRouter.like(postId: postId, type: type), showLoader: true) { [weak self](response) in
            guard let data = response?.data else{return}
            self?.post.likeType = data.likeType
            self?.post.isLike = data.isLike 
            self?.relodCell()
        }
    }
}

extension ShowPostViewController {
    private func showAlert(postId:Int, post:HomeModel, cellHeight:CGFloat){
        let alert = UIAlertController(title: "Share".localized, message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share Now".localized, style: .default, handler: { [weak self](_) in
            self?.shareWithouComment(postId: postId)
        }))
        
        alert.addAction(UIAlertAction(title: "Share With Comment".localized, style: .default, handler: { [weak self] (_) in
            let vc  = SharePostViewController(postId: postId, postType: self?.postType ?? .normal, post: post, cellHeight:cellHeight)
            vc.modalPresentationStyle = .formSheet
            self?.present(vc.toNavigation, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = self.view
        
        
        self.present(alert, animated: true)
    }
    private func shareWithouComment(postId:Int){
        
        repo.request(PostModel.self, CoreRouter.shareWithoutComment(postId: postId, privacy: "all")) { (_) in
        }
    }
}
