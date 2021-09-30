//
//  SecretMessagePostTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 3/2/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class SecretMessagePostTableViewCell: UITableViewCell {

    @IBOutlet weak var btnShowUserScreenshotOutlet: UIButton!
    @IBOutlet weak var lblCountScreenShot: UILabel!
    @IBOutlet weak var btnEditPostOutlet: UIButton!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDatePost: UILabel!
    @IBOutlet weak var lblSeeMore: UILabel!
    @IBOutlet weak var lblTextPost: UILabel!
    
    @IBOutlet weak var lblTextSecret: UILabel!
    @IBOutlet weak var lblDateSecret: UILabel!
    
    weak var deleget:HomeCellsProtocol?
    
    private var arrPostNormal = [HomePostNormalViewModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        iniCollectionView()
    }
    
    var item: HomeModel! {
        didSet{
//            imageUser.load(with: item.user?.profileImage)
            imageUser.image = UIImage(named: "avatar")
            lblUserName.text = item.user?.fullname
            lblDatePost.text = item.createdAgo
            let postText = item.text ?? "".removeNewLine
            lblSeeMore.isHidden = postText.count > 50 ? false : true
            lblTextPost.text = postText
            
            let userId = AuthService.userData?.id ?? 0
            let userPostId = item.user?.id ?? 0
            btnEditPostOutlet.isHidden = userId == userPostId ? false : true
            
            if postText.count >= 50 && !(item.isShowFullPost ?? false) {
                let countCharacter = AuthService.userData?.subscribeData?.package?.plan?.charactersPostCount ?? "300"
                let _countCharacter = Int(countCharacter) ?? 0
                let sub = postText.subString(index: _countCharacter)
                lblTextPost.text = sub + "..."
                lblSeeMore.isHidden = false
            }else {
                lblTextPost.text = postText
                lblSeeMore.isHidden = true
            }
            
            // check for if it my pos
            if let arrScreen = item.screenShots, arrScreen.count > 0 {
                lblCountScreenShot.isHidden = false
                btnShowUserScreenshotOutlet.isHidden = false
                lblCountScreenShot.text = String(arrScreen.count)
            }else{
                lblCountScreenShot.isHidden = true
                btnShowUserScreenshotOutlet.isHidden = true
            }
            
            lblTextSecret.text = item.postable?.message
            lblDateSecret.text = item.createdAgo
            getViewModelArray(text: item.text, arrVideos: item.videos, arrImages: item.images)
           
        }
    }
    private func getViewModelArray(text:String?, arrVideos:[Image]?, arrImages:[Image]?){
        
        arrPostNormal.removeAll()
        arrPostNormal =  Helper.getArrayMedia(arrVideos: arrVideos, arrImages:arrImages)
        collectionViewImages.isHidden = arrPostNormal.count == 0 ? true : false
        collectionViewImages.reloadData()
    }
    
    @IBAction func btnShowUsersScreenShotTapped(_ sender: Any) {
        deleget?.didTappedShowUserTakeScreens(postId: item.id ?? 0)
    }
    
    @IBAction func btnShowPostTapped(_ sender: Any) {
        deleget?.didTappedOwnerEditPost(postId: item.id ?? 0, topAnchor: btnEditPostOutlet.bottomAnchor)
    }
}

extension SecretMessagePostTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
}
