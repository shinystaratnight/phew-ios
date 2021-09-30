//
//  OwnerWorkWithPostTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/19/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import UIKit

class OwnerWorkWithPostTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var item: EditPostModel! {
        didSet{
            lblName.text = item.name
            imageIcon.withTint(.mainRed)
            imageIcon.image = UIImage(named: item.imageName)
        }
    }
}
