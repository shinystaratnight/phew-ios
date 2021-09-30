//
//  MainPostTableViewCell.swift
//  Phew
//
//  Created by Mohamed Akl on 8/26/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit
enum HomePostNormalTypeEnum{
    case video
    case image
}
struct HomePostNormalViewModel {
    let type: HomePostNormalTypeEnum
    let coverImageVideo:String?
    let url:String?
}

class MainPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnEditPostOutlet: UIButton!
    @IBOutlet weak var lblSeeMore: UILabel!
    @IBOutlet weak var btnShowUserScreenshotOutlet: UIButton!
    @IBOutlet weak var lblCountScreenShot: UILabel!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imageUSer: CircleImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var btnFavOutlet: UIButton!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var stackActionButtons: UIStackView!

    @IBOutlet weak var lblCountLike: UILabel!
    
    @IBOutlet weak var echoButtonOutlet: UIButton!
    
    weak var deleget:HomeCellsProtocol?
    private var arrPostNormal = [HomePostNormalViewModel]()
    private var likeView: ViewLike2?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        iniCollectionView()
        didTapImages()
        addLongPressGesture()
        likeView = ViewLike2(view: self)
    }
    
    @IBAction func btnShowUsersScreenShotTapped(_ sender: Any) {
        deleget?.didTappedShowUserTakeScreens(postId: item.id ?? 0)
        
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
                guard selectedReact != "cancel" else {
                    return
                }
                self?.btnLikeOutlet.setImage(UIImage(named: selectedReact ?? Helper.getNameReact(tag: -1)), for: .normal)
                self?.deleget?.didTappedRact(reactType: selectedReact ?? Helper.getNameReact(tag: -1), postId: self?.item.id ?? 0)
            }
            likeView?.remove()
        }
    }
    
    @IBAction func likePostBtn(_ sender: Any) {
        deleget?.didTappedLike(cell: self)
    }
    
    @IBAction func starPostBtn(_ sender: Any) {
        deleget?.didTappedWashlist(cell: self)
    }
    
    @IBAction func sharePostBtn(_ sender: Any) {
        deleget?.didTappedShare(cell: self)
    }
    
    @IBAction func commentPostBtn(_ sender: Any) {
        deleget?.didTappedShowPost(cell: self)
    }
    
    @IBAction func btnShowPostTapped(_ sender: Any) {
        deleget?.didTappedOwnerEditPost(postId: item.id ?? 0, topAnchor: btnEditPostOutlet.bottomAnchor)
    }
    
    private func setTextPost() {
        let text  = item.text ?? ""
        lblText.text = text
        let countCharacter = AuthService.userData?.subscribeData?.package?.plan?.charactersPostCount ?? "300"
        let _countCharacter = Int(countCharacter) ?? 0
        lblSeeMore.isHidden = text.count >=  _countCharacter ? false : true
    }
    var item: HomeModel!{
        didSet{
            lblCountLike.text = String(item.likesCount ?? 0)
          
            // set image reacted
            btnLikeOutlet.setImage(UIImage(named: item.likeType ?? Helper.getNameReact(tag: -1)), for: .normal)
            
            // check for if it my pos
            if let arrScreen = item.screenShots, arrScreen.count > 0 {
                lblCountScreenShot.isHidden = false
                btnShowUserScreenshotOutlet.isHidden = false
                lblCountScreenShot.text = String(arrScreen.count)
            }else{
                lblCountScreenShot.isHidden = true
                btnShowUserScreenshotOutlet.isHidden = true
            }

            // check for owner of post
            let userId = AuthService.userData?.id ?? 0
            let userPostId = item.user?.id ?? 0
            btnEditPostOutlet.isHidden = userId == userPostId ? false : true
            
            lblCommentCount.text = String(item.commentsCount ?? 0)
            getViewModelArray(text: item.text, arrVideos: item.videos, arrImages: item.images)
//            imageUSer.load(with: item.user?.profileImage)
            imageUSer.image = UIImage(named: "avatar")
            lblUserName.text = item.user?.fullname?.components(separatedBy: " ").first
            let imageStar: String = (item.isFav ?? false) == true ? "starFill": "star"
            btnFavOutlet.setImage(UIImage(named: imageStar), for: .normal)
            lblCommentCount.text = String(item.commentsCount ?? 0)
            lblDate.text = item.createdAgo ?? ""
            collectionViewImages.reloadData()
        }
    }
    
    private func didTapImages(){
        imageUSer.isUserInteractionEnabled = true
       
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        imageUSer.addGestureRecognizer(tapUserImage)
    }
    
    @objc private func userImageTapped(){
        deleget?.didTappedUserImage(cell: self)
        
    }
}

extension MainPostTableViewCell{
    private func getViewModelArray(text:String?, arrVideos:[Image]?, arrImages:[Image]?){
        lblText.isHidden =  (text ?? "").isEmpty ? true : false
        setTextPost()
        
        arrPostNormal.removeAll()
        arrPostNormal =  Helper.getArrayMedia(arrVideos: arrVideos, arrImages:arrImages)
        
        collectionViewImages.isHidden = arrPostNormal.count == 0 ? true : false
    }
}

extension MainPostTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func iniCollectionView(){
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
       
        collectionViewImages.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPostNormal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewImages.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
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
        
        
        let width = collectionView.frame.width - 20
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
        deleget?.didSelectMedia(cell: self)
    }
    
}
