//
//  SharePostTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class SharePostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCountLike: UILabel!
    @IBOutlet weak var btnShowPostOutlet: UIButton!
    @IBOutlet weak var btnShowUserScreenshotOutlet: UIButton!
    @IBOutlet weak var lblCountScreenShot: UILabel!
    @IBOutlet weak var lblSeeMorePost: UILabel!
    @IBOutlet weak var lblSeeMoreReplyPost: UILabel!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var btnFavOutlet: UIButton!
    @IBOutlet weak var collectionViewReply: UICollectionView!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNmaeUser: UILabel!
    @IBOutlet weak var imageUser: CircleImageView!
    
    @IBOutlet weak var imagePostUser: UIImageView!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var lblPostUSerName: UILabel!
    @IBOutlet weak var lblCountComment: UILabel!
    @IBOutlet weak var colectionViewImages: UICollectionView!
    
    private var arrPostNormal = [HomePostNormalViewModel]()
    private var arrReply = [HomePostNormalViewModel]()
    weak var delegate:HomeCellsProtocol?
    private var likeView: ViewLike2?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        iniCollectionView()
        didTapImages()
        likeView = ViewLike2(view: self)
        addLongPressGesture()
    }
    func addLongPressGesture(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        longPress.minimumPressDuration = 0.5
        self.btnLikeOutlet.addGestureRecognizer(longPress)
    }
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            likeView?.setView(leadingAnchor: btnLikeOutlet.leadingAnchor, bouttomAnchor: (btnLikeOutlet.centerXAnchor))
            
        }else if sender.state == .changed {
            let x = sender.location(in: self).x
            likeView?.animation(location: x)
        }
        
        else if sender.state == .ended {
            likeView?.didSelectReact = { [weak self] selectedReact in
                self?.btnLikeOutlet.setImage(UIImage(named: selectedReact ?? Helper.getNameReact(tag: -1)), for: .normal)
                self?.delegate?.didTappedRact(reactType: selectedReact ?? Helper.getNameReact(tag: -1), postId: self?.item.id ?? 0)
            }
            likeView?.remove()
        }
    }
    
    private func setSeeMoreForText() {
        let repyText = item.text ?? "".removeNewLine
        let postText = item.postable?.text ?? ""
        
        lblSeeMorePost.isHidden = postText.count > 50 ? false : true
        lblPost.text = postText
        
        if repyText.count >= 50 && !(item.isShowFullPost ?? false) {
            let countCharacter = AuthService.userData?.subscribeData?.package?.plan?.charactersPostCount ?? "300"
            let _countCharacter = Int(countCharacter) ?? 0
            let sub = repyText.subString(index: _countCharacter)
            lblReply.text = sub + "..."
            lblSeeMoreReplyPost.isHidden = false
        }else {
            lblReply.text = repyText
            lblSeeMoreReplyPost.isHidden = true
        }
    }
    var item:HomeModel!{
        didSet{
            lblCountLike.text = String(item.likesCount ?? 0)
            lblDate.text = item.createdAgo
            lblNmaeUser.text = item.user?.fullname?.components(separatedBy: " ").first?.appending(" said")
//            imageUser.load(with: item.user?.profileImage)
            imageUser.image = UIImage(named: "avatar")
            lblCountComment.text = String(item.commentsCount ?? 0)
            // set image reacted
            btnLikeOutlet.setImage(UIImage(named: item.likeType ?? Helper.getNameReact(tag: -1)), for: .normal)
            
            
            // check for onwer of post
            let userId = AuthService.userData?.id ?? 0
            let userPostId = item.user?.id ?? 0
            btnShowPostOutlet.isHidden = userId == userPostId ? false : true
            
            getViewModelArrayReply(text: item.text, arrVideos: item.videos, arrImages: item.images)
            let imageStar: String = (item.isFav ?? false) == true ? "starFill": "star"
            btnFavOutlet.setImage(UIImage(named: imageStar), for: .normal)
            // post
            getViewModelArrayPost(text: item.postable?.text, arrVideos: item.postable?.videos, arrImages: item.postable?.images)
            
//            imagePostUser.load(with: item.postable?.user?.profileImage)
            imagePostUser.image = UIImage(named: "avatar")
            lblPostDate.text = item.postable?.createdAgo
            lblPostUSerName.text = item.postable?.user?.fullname?.components(separatedBy: " ").first
            
            colectionViewImages.reloadData()
            collectionViewReply.reloadData()
            
            // check for if it my pos
            if let arrScreen = item.screenShots, arrScreen.count > 0 {
                lblCountScreenShot.isHidden = false
                btnShowUserScreenshotOutlet.isHidden = false
                lblCountScreenShot.text = String(arrScreen.count)
            }else{
                lblCountScreenShot.isHidden = true
                btnShowUserScreenshotOutlet.isHidden = true
            }
            setSeeMoreForText()
            
        }
    }
    
    @IBAction func btnScreenShotTapped(_ sender: Any) {
        delegate?.didTappedShowUserTakeScreens(postId: item.id ?? 0)
    }
    
    private func didTapImages(){
        
        imageUser.isUserInteractionEnabled = true
        imagePostUser.isUserInteractionEnabled = true
        
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        
        let tapUserImageReplay = UITapGestureRecognizer(target: self, action: #selector(userImageTappedReply))
        
        imageUser.addGestureRecognizer(tapUserImage)
        imagePostUser.addGestureRecognizer(tapUserImageReplay)
    }
    
    
    @IBAction func btnShowPostTapped(_ sender: Any) {
        delegate?.didTappedOwnerEditPost(postId: item.id ?? 0, topAnchor: btnShowPostOutlet.bottomAnchor)
    }
    @objc private func userImageTapped(){
        delegate?.didTappedUserImage(cell: self)
        
    }
    @objc private func userImageTappedReply(){
        delegate?.didTappedUserImageReplay(cell: self)
    }
    
    @IBAction func likePostBtn(_ sender: Any) {
        delegate?.didTappedLike(cell: self)
    }
    
    @IBAction func starPostBtn(_ sender: Any) {
        delegate?.didTappedWashlist(cell: self)
    }
    
    @IBAction func sharePostBtn(_ sender: Any) {
        delegate?.didTappedShare(cell: self)
    }
    
    @IBAction func commentPostBtn(_ sender: Any) {
        delegate?.didTappedShowPost(cell: self)
    }
}
extension SharePostTableViewCell{
    private func getViewModelArrayPost(text:String?, arrVideos:[Image]?, arrImages:[Image]?){
        let reply =  text ?? ""
        lblPost.isHidden = reply.isEmpty ? true : false
        //        lblPost.text = reply
        
        arrPostNormal.removeAll()
        arrPostNormal = Helper.getArrayMedia(arrVideos: arrVideos, arrImages: arrImages)
        
        colectionViewImages.isHidden = arrPostNormal.count == 0 ? true : false
    }
    
    private func getViewModelArrayReply(text:String?, arrVideos:[Image]?, arrImages:[Image]?){
        lblReply.isHidden =  (text ?? "").isEmpty ? true : false
        //        lblReply.text = text
        
        arrReply.removeAll()
        arrReply = Helper.getArrayMedia(arrVideos: arrVideos, arrImages: arrImages)
        
        collectionViewReply.isHidden = arrReply.count == 0 ? true : false
    }
    
    
}

extension SharePostTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func iniCollectionView(){
        colectionViewImages.delegate = self
        colectionViewImages.dataSource = self
        colectionViewImages.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
        
        collectionViewReply.delegate = self
        collectionViewReply.dataSource = self
        collectionViewReply.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colectionViewImages{
            return arrPostNormal.count
        }else{
            return arrReply.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colectionViewImages {
            let cell = colectionViewImages.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
            cell.item = arrPostNormal[indexPath.row]
            cell.layer.cornerRadius = 5
            if indexPath.row == 2, arrPostNormal.count > 3{
                cell.count = arrPostNormal.count
            }
            return cell
        }else{
            let cell = collectionViewReply.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
            cell.item = arrReply[indexPath.row]
            cell.layer.cornerRadius = 5
            if indexPath.row == 2, arrReply.count > 3{
                cell.count = arrReply.count
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == colectionViewImages {
            return  getMinLineSpacing(arr: arrPostNormal)
        }else{
            return  getMinLineSpacing(arr: arrReply)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == colectionViewImages{
            return getCellSize(collectionView: colectionViewImages, arr: arrPostNormal)
        }else{
            return  getCellSize(collectionView: collectionViewReply, arr: arrReply)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == colectionViewImages {
            return getEdgeInsect(arr: arrPostNormal)
        }else{
            return getEdgeInsect(arr: arrReply)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewReply{
            delegate?.didSelectMedia(cell: self)
        }else{
            delegate?.didSelectMediaRplay(cell: self)
        }
    }
    
    private func getCellSize(collectionView:UICollectionView, arr:[HomePostNormalViewModel])->CGSize{
        let width = collectionView.frame.width - 20
        switch arr.count {
        case 1:
            return CGSize(width: collectionView.frame.width, height: 120)
        case 2:
            
            return CGSize(width:width / 2, height: 120)
        case 3:
            return CGSize(width: width / 3, height: 120)
        default:
            return CGSize(width: width / 3 , height: 120)
        }
    }
    private func getEdgeInsect(arr:[HomePostNormalViewModel])->UIEdgeInsets{
        if arr.count == 1{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    
    private func getMinLineSpacing(arr:[HomePostNormalViewModel])->CGFloat{
        if arr.count == 1{
            return 0
        }else{
            return 5
        }
    }
}
