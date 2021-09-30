//
//  FriendNameTableViewCell.swift
//  Phew
//
//  Created by Ahmed Elesawy on 11/17/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import UIKit

class FriendNameTableViewCell: UITableViewCell {
    @IBOutlet weak var imageUSer: UIImageView!
    
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var item : User!{
        didSet{
            imageUSer.load(with: item.profileImage)
            lblUserName.text  = item.fullname ?? ""
            if item.isSelected {
                lblSelected.backgroundColor = .mainColor
            }else{
                lblSelected.backgroundColor = .white
            }
        }
    }
    
    var isHideSelectedUser: Bool! {
        didSet {
            lblSelected.isHidden = isHideSelectedUser
        }
    }
}
