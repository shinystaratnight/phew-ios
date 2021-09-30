//
//  LocationPostTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/11/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class LocationPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnEditPostOutlet: UIButton!
    @IBOutlet weak var btnShowUserScreenshotOutlet: UIButton!
    @IBOutlet weak var lblCountScreenShot: UILabel!
  
    @IBOutlet weak var btnShareOutlet: UIButton!
    
    @IBOutlet weak var stackOnlyYou: UIStackView!
    @IBOutlet weak var btnFavOutlet: UIButton!
    @IBOutlet weak var stackMoreThanOneFrids: UIStackView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
   
    @IBOutlet weak var btnAllFriendOutlet: UIButton!
    @IBOutlet weak var btnFirstFriendOutlet: UIButton!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    private var arrMentions = [User]()
    weak var delegate:HomeCellsProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        iniCollectionView()
        didTapImages()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = .none
        // Configure the view for the selected state
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
            let location = Helper.covertStringToObject(ofType:LocationModel.self,value: item?.location?.data ?? "")?.address
            lblLocation.text =   location
            
            lblDate.text = item.createdAgo
           
            
            // check for onwer of post
            let userId = AuthService.userData?.id ?? 0
            let userPostId = item.user?.id ?? 0
            btnEditPostOutlet.isHidden = userId == userPostId ? false : true
            let imageStar: String = (item.isFav ?? false) == true ? "starFill": "star"
            btnFavOutlet.setImage(UIImage(named: imageStar), for: .normal)
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
                collectionViewImages.reloadData()
                let name = arrMentions[0].fullname?.components(separatedBy: " ").first
                btnFirstFriendOutlet.setTitle(name, for: .normal)
                
                stackOnlyYou.isHidden = false
                collectionViewImages.isHidden = false
               showFriends(arrUsers: arrMentions)
               
                
            }else{
                stackOnlyYou.isHidden = true
                collectionViewImages.isHidden = true
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
    
    @IBAction func btnWashlistTapped(_ sender: Any) {
        delegate?.didTappedWashlist(cell: self)
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        delegate?.didTappedShare(cell: self)
    }
    @IBAction func btnShowPostTapped(_ sender: Any) {
        delegate?.didTappedOwnerEditPost(postId: item.id ?? 0, topAnchor: btnEditPostOutlet.bottomAnchor)
    }
    
    
    private func showFriends(arrUsers:[User]){
        if arrUsers.count > 1 {
            stackMoreThanOneFrids.isHidden = false
            let count = String(arrUsers.count - 1)
            btnAllFriendOutlet.setTitle("\(count) Others", for: .normal)
            
        }else{
            stackMoreThanOneFrids.isHidden = true
        }
    }
    
}

extension LocationPostTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private func iniCollectionView(){
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
       
        collectionViewImages.register(UINib(nibName: "UserImageLocationPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserImageLocationPostCollectionViewCell")
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrMentions.count > 4{
            return 4
        }else{
            return arrMentions.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewImages.dequeueReusableCell(withReuseIdentifier: "UserImageLocationPostCollectionViewCell", for: indexPath) as! UserImageLocationPostCollectionViewCell
        cell.layer.cornerRadius = 15
        if indexPath.row == 3 {
            cell.configCell(img: nil, count: arrMentions.count - 3)
        }else{
            cell.configCell(img: arrMentions[indexPath.row].profileImage, count: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    

}
