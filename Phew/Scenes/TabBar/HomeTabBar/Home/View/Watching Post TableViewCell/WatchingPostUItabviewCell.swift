//
//  WatchingPostUItabviewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/12/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class WatchingPostUItabviewCell: UITableViewCell {
    @IBOutlet weak var btnEditPostOutlet: UIButton!
   
    @IBOutlet weak var btnShowUserScreenshotOutlet: UIButton!
    @IBOutlet weak var lblCountScreenShot: UILabel!
    
    @IBOutlet weak var btnShareOutlet: UIButton!
    @IBOutlet weak var btnWashListOutlet: UIButton!
    @IBOutlet weak var stackOnlyYou: UIStackView!
    @IBOutlet weak var stackMoreThanOneFrids: UIStackView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnFavOutlet: UIButton!
    @IBOutlet weak var btnFirstFiriendNameoutlet: UIButton!
    @IBOutlet weak var btnCountFriendsOutLet: UIButton!
    
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    private var arrMentions = [User]()
    weak var delegate:HomeCellsProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        didTapImages()
    }
    
    @IBAction func btnShowUsersScreenShotTapped(_ sender: Any) {
        delegate?.didTappedShowUserTakeScreens(postId: item.id ?? 0)
        
    }
    var item:HomeModel!{
        
        didSet{
//            imageUser.load(with: item.user?.profileImage)
            imageUser.image = UIImage(named: "avatar")
            let name  = item.user?.fullname ?? ""
            lblUserName.text = name.components(separatedBy: " ").first
            
            let filmName = Helper.covertStringToObject(ofType: MoviFilm.self, value:item.watching?.data ?? "" )?.originalTitle ?? ""
            let filmArr  = filmName.components(separatedBy: " ")
            
            lblFileName.text = filmArr.count > 3  ? (filmArr[0] + " " + filmArr[1] + " " + filmArr[3] + "...") : filmName
            lblDate.text = item.createdAgo
            
            let imageStar: String = (item.isFav ?? false) == true ? "starFill": "star"
            btnFavOutlet.setImage(UIImage(named: imageStar), for: .normal)
            
            
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
            if Helper.isMentionFriends(mentions: item.mentions) {
                arrMentions = item.mentions!
                
                let firendName = arrMentions[0].fullname?.components(separatedBy: " ").first
                
                btnFirstFiriendNameoutlet.setTitle(firendName, for: .normal)
                stackOnlyYou.isHidden = false
                
                showFriends(arrUsers: arrMentions)
            }else{
                stackOnlyYou.isHidden = true
            }
            
        }
    }
    
    private func didTapImages(){
        imageUser.isUserInteractionEnabled = true
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        imageUser.addGestureRecognizer(tapUserImage)
        
    }
    
    @objc private func userImageTapped(){
        delegate?.didTappedUserImage(cell: self)
        
    }
    
    @IBAction func btnFirstFriendTapped(_ sender: Any) {
        delegate?.didTappedFirstFrinds(cell: self)
    }
    
    @IBAction func btnShowAllFriendTapped(_ sender: Any) {
        delegate?.didTappedAllFrinds(cell: self)
    }
    
    
    @IBAction func btnShowPostTapped(_ sender: Any) {
        delegate?.didTappedOwnerEditPost(postId: item.id ?? 0, topAnchor: btnEditPostOutlet.bottomAnchor)
    }
    
    @IBAction func btnWashlistTapped(_ sender: Any) {
        delegate?.didTappedWashlist(cell: self)
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        delegate?.didTappedShare(cell: self)
    }
    
    private func showFriends(arrUsers:[User]){
        if arrUsers.count > 1 {
            stackMoreThanOneFrids.isHidden = false
            let count =  String(arrUsers.count - 1) + " Other".localize
            btnCountFriendsOutLet.setTitle(count, for: .normal)
            
        }else{
            stackMoreThanOneFrids.isHidden = true
        }
    }
    
}
