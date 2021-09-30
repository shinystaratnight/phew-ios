//
//  UserImageLocationPostCollectionViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/11/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class UserImageLocationPostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configCell(img: String?, count: Int?){
        if let _count = count {
            imageUser.backgroundColor = .white
            lblCount.isHidden = false
            lblCount.text = "+\(_count)"
        }else{
//            imageUser.load(with: img)
            imageUser.image = UIImage(named: "avatar")
            lblCount.isHidden = true
        }
        
    }

}
