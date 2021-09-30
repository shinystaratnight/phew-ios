//
//  UserInformationHeaderTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/23/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol UserInformationHeaderTableViewCellProtocol: AnyObject {
    func showAllFriends()
    func didTappedNormal()
    func didTappedLocation()
    func didTappedWatching()
    func didTappedFavourit()
    func didTappedSecretQuestion(userId: Int)
    
    func didTappedAddFriend(userId: Int)
    func didTappedCancelFriendRequest(userId: Int)
    func didTappedRejectFriendRequest(userId: Int)
    func didTappedAcceptFriendRequest(userId: Int)
    func didTappedRemoveFriendRequest(userId: Int)
    
    func didTappedProfileSlider(profile images: [HomePostNormalViewModel])
    func didTappedFollowFriend(userId: Int)
    
    func chatWithUser(userId: Int)
    func showMessages()
}

class UserInformationHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnAddFriendOutlet: UIButton!
    @IBOutlet weak var stackQuestions: UIStackView!
    @IBOutlet weak var stackMessages: UIStackView!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumberFollower: UILabel!
    @IBOutlet weak var lblNumberPosts: UILabel!
    @IBOutlet weak var lblNumberFollwing: UILabel!
    @IBOutlet weak var lblNumberFriends: UILabel!
    @IBOutlet weak var btnFollowOutlet: UIButton!
    @IBOutlet weak var imageVerified: UIImageView!
    @IBOutlet weak var imagePermium: UIImageView!
    @IBOutlet weak var btnFavOutlet: UIButton!
    @IBOutlet weak var btnLocationOutlet: UIButton!
    @IBOutlet weak var btnWatchingOutlet: UIButton!
    @IBOutlet weak var btnNormalOutlet: UIButton!
    @IBOutlet weak var btnFriendsOutlet: UIButton!
    
    @IBOutlet weak var btnAcceptFriendOutLet: UIButton!
    @IBOutlet weak var btnCancelFirendOutlet: UIButton!
    @IBOutlet weak var btnRejectFriendOutlet: UIButton!
    @IBOutlet weak var btnUnfriendOutlet: UIButton!
    
    weak var deleget: UserInformationHeaderTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(messagesTapped))
        stackMessages.addGestureRecognizer(tap)
        
        let tapQuestion = UITapGestureRecognizer(target: self, action: #selector(sendScretMessage))
        
        stackQuestions.isUserInteractionEnabled = true
        stackQuestions.addGestureRecognizer(tapQuestion)
    }
    
    @IBAction func btnFriendsTapped(_ sender: Any) {
        deleget?.showAllFriends()
    }
    
    @objc
    private func sendScretMessage() {
        deleget?.didTappedSecretQuestion(userId: item?.id ?? 0 )
    }
    
    @objc
    private func messagesTapped() {
        guard let userId = item?.id, let myId = AuthService.userData?.id else {return}
        if userId == myId {
            deleget?.showMessages()
        }
        else {
            deleget?.chatWithUser(userId: item?.id ?? 0)
        }
    }
    
    private func firendRequestStatus() {
        guard item?.isFriendRequest ?? false else {return}
        if (item?.senderFriendRequest ?? "") == "me" {
            btnCancelFirendOutlet.isHidden = false
            btnAddFriendOutlet.isHidden = true
        }else {
            btnAcceptFriendOutLet.isHidden = false
            btnRejectFriendOutlet.isHidden = false
            btnAddFriendOutlet.isHidden = true
        }
    }
    
    private func isMyfriend() {
        guard item?.isFriendRequest ?? false == false else {return}
        if item?.isFriend ?? false {
            btnAddFriendOutlet.isHidden = true
            btnUnfriendOutlet.isHidden = false
        }else {
            btnAddFriendOutlet.isHidden = false
        }
    }
    
    private func hideAllButtonsFriend() {
        [btnAddFriendOutlet, btnUnfriendOutlet, btnCancelFirendOutlet, btnAcceptFriendOutLet, btnRejectFriendOutlet].forEach({
            $0?.isHidden = true
        })
    }
    
    @IBAction func btnAccetpfrined(_ sender: Any) {
        deleget?.didTappedAcceptFriendRequest(userId: item?.id ?? 0)
    }
    
    @IBAction func btnUnFriend(_ sender: Any) {
        deleget?.didTappedRemoveFriendRequest(userId: item?.id ?? 0)
    }
    
    @IBAction func btnCancelFriend(_ sender: Any) {
        deleget?.didTappedCancelFriendRequest(userId: item?.id ?? 0)
    }
    
    @IBAction func btnRejectFriend(_ sender: Any) {
        deleget?.didTappedRejectFriendRequest(userId: item?.id ?? 0)
    }
    
    private func setTappedUerProfile() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentSlider))
        imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(tap)
    }
    @objc private func presentSlider() {
        guard let profileImages = item?.profileImages?.map({HomePostNormalViewModel(type: .image, coverImageVideo: nil, url: $0.image)}) else{return}
        deleget?.didTappedProfileSlider(profile: profileImages)
      
    }
    
    private func setProfileImagesPoints() {
        // set background image profile
        let viewProfileImages = UIView()
        let color = UIColor.black.withAlphaComponent(0.2)
        viewProfileImages.backgroundColor = color
        
        imageProfile.addSubview(viewProfileImages)
        
        viewProfileImages.heightAnchorConstant(constant: 20)
        viewProfileImages.leadingAnchorSuperView()
        viewProfileImages.trailingAnchorSuperView()
        viewProfileImages.bottomAnchorSuperView()

        // set stack for images profile
        let stackProfileImages = UIStackView()
        stackProfileImages.axis = .horizontal
        
        viewProfileImages.addSubview(stackProfileImages)
        stackProfileImages.centerXInSuperview()
        stackProfileImages.bottomAnchorToView(anchor: imageProfile.bottomAnchor, constant: -10)
        
        stackProfileImages.backgroundColor = .clear
        stackProfileImages.spacing = 5
        stackProfileImages.distribution = .fillEqually
        stackProfileImages.alignment = .center
        
        item?.profileImages?.forEach({
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.LightGray
            lbl.withWidth(4)
            lbl.withHeight(4)
            lbl.clipsToBounds = true
            lbl.cornerRadius = 2
            stackProfileImages.addArrangedSubview(lbl)
            print($0)
        })
    }
    var item: User? {
        didSet{
            setTappedUerProfile()
            setProfileImagesPoints()
            hideAllButtonsFriend()
            lblName.text = item?.fullname
            imageProfile.load(with: item?.profileImage)

            imagePermium.image = (item?.isSubscribed ?? false) ? #imageLiteral(resourceName: "premium") : nil
            imageVerified.image = (item?.isVerified ?? false) ? #imageLiteral(resourceName: "verified") : nil
            
            lblNumberFriends.text = String(item?.friendsCount ?? 0)
            lblNumberFollower.text = String(item?.followerCount ?? 0)
            lblNumberFollwing.text = String(item?.followingCount ?? 0)
            lblNumberPosts.text = String(item?.postsCount ?? 0)
            
            let followTitel = (item?.isFollow ?? false) ? "Following".localize : "Follow".localize
            btnFollowOutlet.setTitle(followTitel, for: .normal)
            
            guard let userId = item?.id, let myId = AuthService.userData?.id else {return}
            
            if userId == myId {
                btnFollowOutlet.isHidden = true
                stackQuestions.isHidden = true
                btnFriendsOutlet.isHidden = false
                lblNumberFriends.isHidden = false
            }else{
                btnFollowOutlet.isHidden = false
                stackQuestions.isHidden = false
                lblNumberFriends.isHidden = true
                btnAddFriendOutlet.isHidden = false
                btnFriendsOutlet.isHidden = true
                firendRequestStatus()
                isMyfriend()
            }
        }
    }
    
    @IBAction func btnNormalTapped(_ sender: UIButton) {
        setUnSelectdImages()
        sender.setImage(#imageLiteral(resourceName: "friends"), for: .normal)
        btnNormalOutlet.tintColor = .mainColor
        deleget?.didTappedNormal()
    }
    
    @IBAction func btnLocationTapped(_ sender: UIButton) {
        setUnSelectdImages()
        sender.setImage(#imageLiteral(resourceName: "location_a"), for: .normal)
        deleget?.didTappedLocation()
    }
    
    @IBAction func btnWatchingTapped(_ sender: UIButton) {
        setUnSelectdImages()
        sender.setImage(#imageLiteral(resourceName: "watching_a"), for: .normal)
        deleget?.didTappedWatching()
    }
    
    @IBAction func btnFavouritTapped(_ sender: UIButton) {
        setUnSelectdImages()
        sender.setImage(#imageLiteral(resourceName: "fav_a"), for: .normal)
        deleget?.didTappedFavourit()
    }
    
    private func setUnSelectdImages() {
        btnFavOutlet.setImage(#imageLiteral(resourceName: "star_post"), for: .normal)
        btnLocationOutlet.setImage(#imageLiteral(resourceName: "Path 1780"), for: .normal)
        btnWatchingOutlet.setImage(#imageLiteral(resourceName: "watching_in"), for: .normal)
        btnNormalOutlet.setImage(#imageLiteral(resourceName: "friends"), for: .normal)
        btnNormalOutlet.tintColor = .lightGray
    }
    
    @IBAction func btnAddFriendTapped(_ sender: Any) {
        deleget?.didTappedAddFriend(userId: item?.id ?? 0)
    }
    
    @IBAction func btnFollowFriendTapped(_ sender: Any) {
        deleget?.didTappedFollowFriend(userId: item?.id ?? 0)
    }
}
