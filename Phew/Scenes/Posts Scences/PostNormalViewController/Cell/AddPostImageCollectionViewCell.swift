//
//  AddPostImageCollectionViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/16/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

protocol AddPostImageCollectionViewCellProtocol:AnyObject {
    func deleteCell<T:UICollectionViewCell>(cell:T)
}

class AddPostImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imagePost: UIImageView!
    weak var delegte:AddPostImageCollectionViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
    var item:AddPostNormalModel!{
        didSet{
            imagePost.image = item.image ?? #imageLiteral(resourceName: "placeHolder")
        }
    }

    @IBAction func btnDeleteCellTapped(_ sender: Any) {
        delegte?.deleteCell(cell: self)
    }
}
