//
//  ImageNormalPostCollectionViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/9/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class ImageNormalPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imagePause: UIImageView!
    @IBOutlet weak var imagePost: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item:HomePostNormalViewModel!{
        didSet{
            lblCount.isHidden  = true
            switch item.type {
            case .video:
                imagePause.isHidden = false
                imagePost.load(with: item.coverImageVideo)
            case .image:
                imagePause.isHidden = true
                imagePost.load(with: item.url)
                imagePost.layer.cornerRadius = 5
                imagePost.clipsToBounds = true
            }
        }
    }
    
    var count:Int!{
        didSet{
            imagePause.isHidden = true
            lblCount.isHidden  = false
            lblCount.text =   "+" + String((count - 3))
        }
    }
    
    var image:UIImage!{
        didSet{
            lblCount.isHidden = true
            imagePause.isHidden = true
            imagePost.image = image
        }
    }
}
