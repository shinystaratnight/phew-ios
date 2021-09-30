//
//  CommentTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/22/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol CommentTableViewCellProttocol: AnyObject {
    func didTappedCollectionImages(cell: CommentTableViewCell)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    private var arrImages:[Image] = []
    weak var deleget: CommentTableViewCellProttocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        iniCollectionView()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var item:CommentModel!{
        didSet{
            lblName.text = item.user?.username
            lblComment.text = item.text
            imageUser.load(with: item.user?.profileImage)
            
            if let images = item.images, images.count > 0 {
                arrImages = images
                collectionViewImages.isHidden = false
                collectionViewImages.reloadData()
            }else{
                collectionViewImages.isHidden = true
            }
        }
    }
    
}

extension CommentTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    private func iniCollectionView(){
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.register(UINib(nibName: "ImageNormalPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageNormalPostCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewImages.dequeueReusableCell(withReuseIdentifier: "ImageNormalPostCollectionViewCell", for: indexPath) as! ImageNormalPostCollectionViewCell
        let item = HomePostNormalViewModel(type: .image, coverImageVideo: nil, url: arrImages[indexPath.row].data)
        cell.item = item
            
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        if indexPath.row == 2, arrImages.count > 3 {
            cell.count = arrImages.count
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if arrImages.count == 1{
            return 0
        }else{
            return 5
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = collectionView.frame.width - 20
        switch arrImages.count {
        case 1:
            return CGSize(width: collectionView.frame.width, height: 120)
        case 2:
            
            return CGSize(width:width / 2, height: 50)
        case 3:
            return CGSize(width: width / 3, height: 50)
        default:
            return CGSize(width: width / 3 , height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if arrImages.count == 1{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleget?.didTappedCollectionImages(cell: self)
    }
    
}
