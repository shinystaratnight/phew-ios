//
//  SharePostLocationTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/11/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class SharepostWatchingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnEditPostOutlet: UIButton!
    @IBOutlet weak var lblCountLike: UILabel!
    // Share
    @IBOutlet weak var btnShowUserScreenshotOutlet: UIButton!
    @IBOutlet weak var lblCountScreenShot: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imageUser: CircleImageView!
    @IBOutlet weak var collectiobViewImagewPost: UICollectionView!
    @IBOutlet weak var btnFavOutlet: UIButton!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    // post
    @IBOutlet weak var stackOnlyYou: UIStackView!
    @IBOutlet weak var stackMoreThanOneFrids: UIStackView!
    @IBOutlet weak var imageUserPost: UIImageView!
    @IBOutlet weak var lblFilName: UILabel!
    @IBOutlet weak var lblUserNamePost: UILabel!
    @IBOutlet weak var btnCountFriendsOutlet: UIButton!
    @IBOutlet weak var btnFirstFriendOutlet: UIButton!
    @IBOutlet weak var lblDatePost: UILabel!
    @IBOutlet weak var lblCountComment: UILabel!
    
    private var arrMentions = [User]()
    private var arrPostNormal = [HomePostNormalViewModel]()
    weak var delegate:HomeCellsProtocol?
    private var likeView: ViewLike2?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iniCollectionView()
        self.selectionStyle = .none
        didTapImages()
        addLongPressGesture()
        likeView = ViewLike2(view: self)
    }
    
    func addLongPressGesture(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
            longPress.minimumPressDuration = 0.5
            self.btnLikeOutlet.addGestureRecognizer(longPress)
        }
    
    @IBAction func btnShowUsersScreenShotTapped(_ sender: Any) {
        delegate?.didTappedShowUserTakeScreens(postId: item.id ?? 0)
        
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
    
    var item:HomeModel!{
        didSet{
            lblCountLike.text = String(item.likesCount ?? 0)
            // share values
//            imageUser.load(with: item.user?.profileImage)
            imageUser.image = UIImage(named: "avatar")
            lblUserName.text = item.user?.fullname?.components(separatedBy: " ").first
            lblDate.text = item.createdAgo ?? ""
            lblCountComment.text = String(item.commentsCount ?? 0)
            // set react image
            btnLikeOutlet.setImage(UIImage(named: item.likeType ?? Helper.getNameReact(tag: -1)), for: .normal)
            getArryPostImages(text: item.text, arrVideos: item.videos, arrImages: item.images)
            collectiobViewImagewPost.reloadData()
            // post values
            imageUserPost.image = UIImage(named: "avatar")
//            imageUserPost.load(with: item.postable?.user?.profileImage)
            lblUserNamePost.text = item.postable?.user?.fullname?.components(separatedBy: " ").first
            
            
            // check for onwer of post
            let userId = AuthService.userData?.id ?? 0
            let userPostId = item.user?.id ?? 0
            btnEditPostOutlet.isHidden = userId == userPostId ? false : true
            
            
            // check for if it my pos
            if let arrScreen = item.screenShots, arrScreen.count > 0 {
                lblCountScreenShot.isHidden = false
                btnShowUserScreenshotOutlet.isHidden = false
                lblCountScreenShot.text = String(arrScreen.count)
            }else{
                lblCountScreenShot.isHidden = true
                btnShowUserScreenshotOutlet.isHidden = true
            }
            let filmName = Helper.covertStringToObject(ofType: MoviFilm.self, value:item.postable?.watching?.data ?? "" )?.originalTitle ?? ""
            let filmArr  = filmName.components(separatedBy: " ")
            
            lblFilName.text = filmArr.count > 3  ? (filmArr[0] + " " + filmArr[1] + " " + filmArr[3] + "...") : filmName
            
            let imageStar: String = (item.isFav ?? false) == true ? "starFill": "star"
            btnFavOutlet.setImage(UIImage(named: imageStar), for: .normal)
            
            if Helper.isMentionFriends(mentions: item.postable?.mentions) {
                arrMentions = (item.postable?.mentions!)!
                btnFirstFriendOutlet.setTitle(arrMentions[0].fullname?.components(separatedBy: " ").first, for: .normal)
                lblDatePost.text = item.postable?.createdAgo ?? "" 
                
                stackOnlyYou.isHidden = false
                
                showFriends(arrUsers: arrMentions)
                
            }else{
                stackOnlyYou.isHidden = true
                
            }
        }
    }
    
    private func showFriends(arrUsers:[User]){
        if arrUsers.count > 1 {
            stackMoreThanOneFrids.isHidden = false
            let count = String(arrUsers.count - 1)  + " Other".localize
            btnCountFriendsOutlet.setTitle(count, for: .normal)
            
        }else{
            stackMoreThanOneFrids.isHidden = true
        }
       
    }
    
    private func didTapImages(){
        
        imageUser.isUserInteractionEnabled = true
        imageUserPost.isUserInteractionEnabled = true
       
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        
        let tapUserImageReplay = UITapGestureRecognizer(target: self, action: #selector(userImageTappedReply))
        
        imageUser.addGestureRecognizer(tapUserImage)
        imageUserPost.addGestureRecognizer(tapUserImageReplay)
        
    }
    
    @objc private func userImageTapped(){
        delegate?.didTappedUserImage(cell: self)
        
    }
    @objc private func userImageTappedReply(){
        delegate?.didTappedUserImageReplay(cell: self)
    }
    
    @IBAction func btnShowReplayTapped(_ sender: Any) {
        delegate?.didTappedShowReplay(cell: self)
    }
    
    @IBAction func btnFirstFriendTapped(_ sender: Any) {
        delegate?.didTappedFirstFrindsReplay(cell: self)
    }
    
    @IBAction func btnShowAllFriendTapped(_ sender: Any) {
        delegate?.didTappedAllFrindsReplay(cell: self)
    }
    
    @IBAction func btnCommentTapped(_ sender: Any) {
        delegate?.didTappedShowReplay(cell: self)
    }
    
    @IBAction func btnWashlistTapped(_ sender: Any) {
        delegate?.didTappedWashlist(cell: self)
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        delegate?.didTappedShare(cell: self)
    }
    
    @IBAction func btnLikeTapped(_ sender: Any) {
         delegate?.didTappedLike(cell: self)
    }
}

extension SharepostWatchingTableViewCell{
    private func getArryPostImages(text:String?, arrVideos:[Image]?, arrImages:[Image]?){
        lblText.isHidden =  (text ?? "").isEmpty ? true : false
        lblText.text = text
        
        arrPostNormal.removeAll()
        
        arrPostNormal =  Helper.getArrayMedia(arrVideos: arrVideos, arrImages:arrImages)
        
        collectiobViewImagewPost.isHidden = arrPostNormal.count == 0 ? true : false
    }
}


extension SharepostWatchingTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func iniCollectionView(){
        collectiobViewImagewPost.delegate = self
        collectiobViewImagewPost.dataSource = self
        
        collectiobViewImagewPost.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPostNormal.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectiobViewImagewPost.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
        cell.item = arrPostNormal[indexPath.row]
        cell.layer.cornerRadius = 5
        if indexPath.row == 2, arrPostNormal.count > 3{
            cell.count = arrPostNormal.count
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        if arrPostNormal.count == 1{
            return 0
        }else{
            return 5
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectiobViewImagewPost.frame.width - 20
        switch arrPostNormal.count {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if arrPostNormal.count == 1{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelectMedia(cell: self)
    }
    
}
